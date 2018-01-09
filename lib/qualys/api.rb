module Qualys
  class Api
    class InvalidResponse < RuntimeError; end
    class AuthorizationRequired < RuntimeError; end
    class Exception < RuntimeError; end

    # Set the current production endpoint
    PRODUCTION_ENDPOINT = 'https://qualysapi.qualys.com/api/2.0/fo/'.freeze

    class << self
      def api_get(url, options = {})
        HTTParty::Basement.default_options.update(headers: {
                                                    'X-Requested-With' => "Qualys Ruby Client v#{Qualys::VERSION}"
                                                  })
        HTTParty::Basement.default_options.update(base_uri: base_uri)
        HTTParty::Basement.default_cookies.add_cookies(Qualys::Config.session_key) unless Qualys::Config.session_key.nil?

        # Send Request
        response = HTTParty.get(url, options)

        # Check if you need to be authorized
        check_response(response)
        # return the response
        response
      end

      #
      #
      def api_post(url, options = {})
        HTTParty::Basement.default_options.update(headers: {
                                                    'X-Requested-With' => "Qualys Ruby Client v#{Qualys::VERSION}"
                                                  })
        HTTParty::Basement.default_options.update(base_uri: base_uri)
        HTTParty::Basement.default_cookies.add_cookies(Qualys::Config.session_key) unless Qualys::Config.session_key.nil?

        # Send Request
        response = HTTParty.post(url, options)

        # Check if you need to be authorized
        check_response(response)
        # return the response
        response
      end

      #
      # Sets the base URI.
      def base_uri=(base_uri)
        Qualys::Config.api_base_uri = base_uri
      end

      private

      def base_uri
        Qualys::Config.api_base_uri.nil? ? PRODUCTION_ENDPOINT : Qualys::Config.api_base_uri
      end

      def check_response(response)
        code = response.code
        raise(Qualys::Api::AuthorizationRequired, 'Please Login Before Communicating With The API') if code.eql?(401)
        raise(Qualys::Api::Exception, response.parsed_response['SIMPLE_RETURN']['RESPONSE']['TEXT']) if code.eql?(403)
        unless code.eql?(200)
          raise(Qualys::Api::InvalidResponse, 'Invalid Response Received' + response.code.to_s + ' ' +
              response.request.last_uri.to_s)
        end
      end
    end
  end
end
