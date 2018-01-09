module Qualys
  class Api
    class InvalidResponse < RuntimeError; end
    class AuthorizationRequired < RuntimeError; end
    class Exception < RuntimeError; end

    # Set the current production endpoint
    PRODUCTION_ENDPOINT = 'https://qualysapi.qualys.com/api/2.0/fo/'.freeze

    class << self
      def api_get(url, options = {})
        options = default_options.merge(options)

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
        options = default_options.merge(options)

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

      def default_options
        options = {
          headers: {
            'X-Requested-With' => "Qualys Ruby Client v#{Qualys::VERSION}",
            'Cookie' => Qualys::Config.session_key.to_s
          },
          base_uri: base_uri
        }

        # proxy support for password with specials chars
        password = URI.decode(proxy.password) if proxy.password

        if proxy.host
          proxy_options = {
            http_proxyaddr: proxy.host,
            http_proxyport: proxy.port,
            http_proxyuser: proxy.user,
            http_proxypass: password
          }
          options.merge!(proxy_options)
        end

        options
      end

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

      def proxy
        encoded_url = URI.encode(Qualys::Config.proxy_uri.to_s)
        URI.parse(encoded_url)
      end
    end
  end
end
