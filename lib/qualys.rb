require 'httparty'
require 'json'
require 'erb'

require 'qualys/version'

require 'qualys/config'
require 'qualys/api'
require 'qualys/auth'

require 'qualys/scans'
require 'qualys/compliance'
require 'qualys/report'

require 'qualys/host'
require 'qualys/vulnerability'

module Qualys
  extend self

  def configure
    block_given? ? yield(Config) : Config
    %w[username password].each do |key|
      next unless Qualys::Config.instance_variable_get("@#{key}").nil?
      raise Qualys::Config::RequiredOptionMissing,
            "Configuration parameter missing: '#{key}'. " \
            'Please add it to the Qualys.configure block'
    end
  end
  alias config configure
end
