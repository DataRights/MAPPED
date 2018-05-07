require 'simplecov'
require 'coveralls'
require 'dotenv/load'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter::new([
    SimpleCov::Formatter::HTMLFormatter
    #Coveralls::SimpleCov::Formatter,
  ])
  add_filter "/test/"
  add_filter "/config/"
end

Coveralls.noisy = true unless ENV['CI']

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

require 'capybara/rails'
require 'capybara/minitest'

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
  config.ignore_ssl_errors
end
