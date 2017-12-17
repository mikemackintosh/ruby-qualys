# frozen_string_literal: true

module Qualys
  # Qualys reports
  class Report < Api
    attr_accessor :header, :host_list, :glossary, :appendices

    # accepted timeout in seconds
    TIMEOUT = 60.0

    class << self
      def find_by_id(id)
        response = api_get('/report/', query: {
                             action: 'fetch',
                             id: id
                           })

        # check if report exist
        return unless response.parsed_response.keys.include?('ASSET_DATA_REPORT')

        Report.new(response.parsed_response)
      end

      # returns the list of the templates
      def templates
        auth = { username: Qualys::Config.username, password: Qualys::Config.password }
        response = HTTParty.get('https://qualysapi.qualys.eu/msp/report_template_list.php',
                                basic_auth: auth)
        response.parsed_response['REPORT_TEMPLATE_LIST']['REPORT_TEMPLATE']
      end

      def delete(id)
        api_post('/report/', query: {
                   action: 'delete',
                   id: id
                 })
      end

      # returns the id of the report
      def create_global_report
        scan_template = templates.detect { |template| template['TITLE'] == 'Technical Report' }
        response = api_post('/report/', query: {
                              action: 'launch',
                              report_title: 'Generated_by_Ruby_Qualys_gem',
                              report_type: 'Scan',
                              output_format: 'xml',
                              template_id: scan_template['ID']
                            })

        response.parsed_response['SIMPLE_RETURN']['RESPONSE']['ITEM_LIST']['ITEM']['VALUE']
      end

      # returns a report global report object.
      # This method can be time consuming and times out after 64 s
      def global_report
        report_id = create_global_report
        report = find_by_id(report_id)

        10.times do
          sleep(TIMEOUT / 10)
          report = find_by_id(report_id)
          break unless report.nil?
        end

        raise Qualys::Report::Exception, 'Report generation timed out' if report.nil?

        delete(report_id)
        report
      end
    end

    def initialize(report)
      @header = report['ASSET_DATA_REPORT']['HEADER']
      @host_list = report['ASSET_DATA_REPORT']['HOST_LIST']['HOST']
      @glossary = report['ASSET_DATA_REPORT']['GLOSSARY']['VULN_DETAILS_LIST']['VULN_DETAILS']
      @appendices = report['ASSET_DATA_REPORT']['APPENDICES']
    end

    def hosts
      hosts ||= host_list.map do |xml_host|
        vulnerabilities = xml_host['VULN_INFO_LIST']['VULN_INFO'].map do |vuln|
          Qualys::Vulnerability.new(vuln, @glossary)
        end
        Qualys::Host.new(xml_host, vulnerabilities)
      end

      hosts
    end
  end
end
