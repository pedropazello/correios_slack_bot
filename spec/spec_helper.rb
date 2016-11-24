$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "correios_slack_bot"
require "correios_slack_bot/correios"
require "vcr"
require "simplecov"
SimpleCov.start

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
