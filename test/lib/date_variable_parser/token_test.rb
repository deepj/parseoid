# frozen_string_literal: true

require "test_helper"

module DateVariableParser
  class TokenTest < ActiveSupport::TestCase
    test "initializes token with type and value" do
      token = Token.new(:day, "5")
      assert_equal :day, token.type
      assert_equal "5", token.value
    end

    test "allows value to be updated" do
      token = Token.new(:month, "3")
      token.value = "4"
      assert_equal "4", token.value
    end

    test "#to_s returns a formatted string based on type" do
      text_token = Token.new(:text, "Hello")
      assert_equal "[text: 'Hello']", text_token.to_s

      day_token = Token.new(:day, "1")
      assert_equal "[day: '1']", day_token.to_s
    end
  end
end
