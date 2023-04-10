require 'rspec'
require 'vcr'
require 'dotenv/load'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<NEWS_API_KEY>") { ENV.fetch("NEWS_API_KEY") }
end
