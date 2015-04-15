module Qualys
  class Scans < Api

    def self.all
      response = api_get("scan/", { :query => { :action => 'list' }})
      scanlist = response.parsed_response['SCAN_LIST_OUTPUT']['RESPONSE']['SCAN_LIST']
      puts scanlist.inspect
    end

    def self.each
      @events.each do |event|
        yield event
      end
    end

  end

  class Scan
  end
end
