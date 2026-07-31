ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "devise"

Dir[Rails.root.join("test/support/**/*.rb")].sort.each { |arquivo| require arquivo }

module ActiveSupport
  class TestCase
    # O banco isolado usado no desenvolvimento atende uma conexão de teste por vez.
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
