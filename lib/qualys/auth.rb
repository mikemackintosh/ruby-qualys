module Qualys
  class Auth < Api
    class InvalidLogin < RuntimeError; end

    attr_reader :name

    # Do Login
    def self.login
      # Request a login
      response = api_post('session/', body: {
                            action: 'login',
                            username: Qualys::Config.username,
                            password: Qualys::Config.password
                          })

      # set the session key
      Qualys::Config.session_key = response.header['Set-Cookie']
      true
    end

    # Set Logout
    def self.logout
      # Request a login
      api_post('session/', body: {
                 action: 'logout'
               })

      # set the session key
      Qualys::Config.session_key = nil
      true
    end
  end
end
