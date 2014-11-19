require File.expand_path("../rails_app/config/environment.rb",  __FILE__)

require 'rspec/rails'

require 'capybara/rspec'
require 'capybara/rails'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  #config.infer_base_class_for_anonymous_controllers = false
  config.color = true
end
