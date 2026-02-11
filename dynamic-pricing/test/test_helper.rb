ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "vcr"

# Configure VCR
VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata! if defined?(RSpec)
  
  # Don't match on host or port - allows cassettes to work across environments
  # (localhost, rate-api, CI servers, etc.)
  config.default_cassette_options = {
    match_requests_on: [:method, :path, :body]
  }
  
  # Keep API key private in cassettes
  config.filter_sensitive_data('<RATE_API_KEY>') do
    ENV['RATE_API_KEY'] || '04aa6f42aa03f220c2ae9a276cd68c62'
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
