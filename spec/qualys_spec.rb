require 'spec_helper'

describe Qualys do
  describe '#configure' do
    it 'configures' do
      expect do
        Qualys.configure do |config|
          config.username = 'Thomas'
          config.password = 'verysafepass'
        end
      end.not_to raise_error

      expect do
        Qualys.configure do |config|
          config.username = 'Thomas'
          config.password = 'verysafepass'
          config.api_base_uri = 'https://qualysapi.qualys.eu/api/2.0/fo/'
        end
      end.not_to raise_error

      expect do
        Qualys.configure do |config|
          config.password = nil
        end
      end.to raise_error("Configuration parameter missing: 'password'. Please add it to the Qualys.configure block")
    end
  end
end
