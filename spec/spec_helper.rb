require 'coveralls'
Coveralls.wear!

require 'qualys'
require 'vcr'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Coveralls::SimpleCov::Formatter
                                                               ])
SimpleCov.start

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.before(:suite) do
    Qualys.configure do |qualys_config|
      qualys_config.username = 'Thomas'
      qualys_config.password = 'thomasPassword'
      qualys_config.api_base_uri = 'https://qualysapi.qualys.eu/api/2.0/fo/'
    end

    VCR.use_cassette('login') do
      Qualys::Auth.login
    end
  end

  config.after(:suite) do
    VCR.use_cassette('logout') do
      Qualys::Auth.logout
    end
  end
end
