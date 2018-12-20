# frozen_string_literal: true

module Qualys
  # a scanned target
  class Host
    attr_accessor :ip, :tracking_method, :hostname, :operating_system, :vuln_info_list, :vulnerabilities

    def initialize(host, vulnerabilities = nil)
      @ip = host['IP']
      @tracking_method = host['TRACKING_METHOD']
      @hostname = host['DNS']
      @operating_system = host['OPERATING_SYSTEM']
      @vuln_info_list = host['VULN_INFO_LIST']
      @vulnerabilities = vulnerabilities
    end
  end
end
