module Qualys
  class Api
    class InvalidResponse < RuntimeError; end
    class AuthorizationRequired < RuntimeError; end
    class Exception < RuntimeError; end

    # Set the current production endpoint
    PRODUCTION_ENDPOINT = 'https://qualysapi.qualys.com/api/2.0/fo/'.freeze

    # Set HTTParty defaults
    HTTParty::Basement.default_options.update(base_uri: PRODUCTION_ENDPOINT)
    HTTParty::Basement.default_options.update(headers: {
                                                'X-Requested-With' => "Qualys Ruby Client v#{Qualys::VERSION}"
                                              })

    #
    #
    def self.api_get(url, options = {})
      unless Qualys::Config.session_key.nil?
        HTTParty::Basement.default_cookies.add_cookies(Qualys::Config.session_key)
      end

      # Send Request
      response = HTTParty.get(url, options)

      # Check if you need to be authorized
      if response.code.eql?(401)
        raise Qualys::Api::AuthorizationRequired, 'Please Login Before Communicating With The API'
      elsif response.code.eql?(403)
        raise Qualys::Api::Exception, response.parsed_response['SIMPLE_RETURN']['RESPONSE']['TEXT']
      elsif !response.code.eql?(200)
        raise Qualys::Api::InvalidResponse, 'Invalid Response Received'
      end

      # return the response
      response
    end

    #
    #
    def self.api_post(url, options = {})
      unless Qualys::Config.session_key.nil?
        HTTParty::Basement.default_cookies.add_cookies(Qualys::Config.session_key)
      end

      # Send Request
      response = HTTParty.post(url, options)

      # Check if you need to be authorized
      if response.code.eql?(401)
        raise Qualys::Api::AuthorizationRequired, 'Please Configure A Username and Password Before Communicating With The API'
      elsif response.code.eql?(403)
        raise Qualys::Api::Exception, response.parsed_response['SIMPLE_RETURN']['RESPONSE']['TEXT']
      elsif response.code.eql?(500)
        raise Qualys::Api::InvalidResponse, 'Invalid Response Received'
      end

      # return the response
      response
    end

    #
    # Sets the base URI.
    def self.base_uri=(base_uri)
      HTTParty::Basement.default_options.update(base_uri: base_uri)
    end
  end
end
