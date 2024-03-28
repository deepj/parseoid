# frozen_string_literal: true

require "test_helper"

module DateVariableParser
  class DateTokenizerTest < ActiveSupport::TestCase
    setup do
      @tokenizer = DateTokenizer.new
    end

    test "returns empty array for nil input" do
      tokens = @tokenizer.tokenize(nil)

      assert_tokens tokens, "[]"
    end

    test "tokenizes plain text without date variables" do
      text = "This is a plain text without any date variables."
      tokens = @tokenizer.tokenize(text)

      assert_tokens tokens, "[text: 'This is a plain text without any date variables.']"
    end

    test "tokenizes text with single date variable" do
      text = "Invoice date: #d#."
      tokens = @tokenizer.tokenize(text)

      assert_tokens tokens, "[date_segment}: [[text: 'Invoice date: '], [day: '0'], [text: '.']]"
    end

    test "tokenizes text with multiple date variables" do
      text = "Invoice issued on #d+1#, month #m#, and year #y#."
      tokens = @tokenizer.tokenize(text)

      assert_tokens tokens, "[date_segment}: [[text: 'Invoice issued on '], [day: '+1'], [text: ', month '], [month: '0'], [text: ', and year '], [year: '0'], [text: '.']]"
    end

    test "handles invalid date variables" do
      text = "This is invalid: #x# and so is this: #d#+."
      tokens = @tokenizer.tokenize(text)

      assert_tokens tokens, "[date_segment}: [[text: 'This is invalid: #x# and so is this: '], [day: '0'], [text: '+.']]"
    end
  end
end
