# frozen_string_literal: true

module Qualys
  # Qualys reports
  class Report < Api
    attr_accessor :header, :host_list, :glossary, :appendices

    class << self
      def find_by_id(id)
        response = api_get('/report/', query: {
                             action: 'fetch',
                             id: id
                           })
        response.parsed_response
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
    end

    def initialize(report)
      @header = report['HEADER']
      @host_list = report['HOST_LIST']['HOST']
      @glossary = report['GLOSSARY']['VULN_DETAILS_LIST']['VULN_DETAILS']
      @appendices = report['APPENDICES']
    end
  end
end
