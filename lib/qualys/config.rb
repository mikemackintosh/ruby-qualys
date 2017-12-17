module Qualys
  module Config
    class RequiredOptionMissing < RuntimeError; end
    extend self

    attr_accessor :username, :password, :session_key

    # Configure Qualys from a hash. This is usually called after parsing a
    # yaml config file such as qualys.yaml.
    #
    # @example Configure Qualys.
    #   config.from_hash({})
    #
    # @param [ Hash ] options The settings to use.
    def from_hash(options = {})
      options.each_pair do |name, value|
        send("#{name}=", value) if respond_to?("#{name}=")
      end
    end

    # Load the settings from a compliant Qualys.yml file. This can be used for
    # easy setup with frameworks other than Rails.
    #
    # @example Configure Qualys.
    #   Qualys.load!("/path/to/qualys.yml")
    #
    # @param [ String ] path The path to the file.
    def load!(path)
      settings = YAML.safe_load(ERB.new(File.new(path).read).result)['api']
      from_hash(settings) if settings.is_a? Hash
    end
  end
end
