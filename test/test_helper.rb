ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
    def assert_tokens(tokens, expected, message = nil)
      tokens_inspect = tokens.present? ? tokens.map(&:to_s).join(", ") : tokens.to_s
      message ||= "Expected: #{expected}\n  Actual: #{tokens_inspect}\n"

      assert_equal tokens_inspect, expected, message
    end
  end
end
