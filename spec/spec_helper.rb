require File.expand_path("../rails_app/config/environment.rb",  __FILE__)

require 'rspec/rails'

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  #config.infer_base_class_for_anonymous_controllers = false
  config.color = true
end

def test_user_password
  load_from_env('TEST_USER_PASSWORD')
end

def test_user_email
  load_from_env('TEST_USER_EMAIL')
end

def load_from_env(variable_name)
  val = ENV[variable_name]
  unless val
    raise "Missing test configuration from environment: #{variable_name}"
  end
  val
end
