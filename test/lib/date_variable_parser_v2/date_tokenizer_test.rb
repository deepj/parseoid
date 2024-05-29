# frozen_string_literal: true

require "test_helper"

module DateVariableParserV2
  class DateTokenizerTest < ActiveSupport::TestCase
    setup do
      @tokenizer = DateVariableParserV2::DateTokenizer.new
    end

    test "handles nil input" do
      tokens = @tokenizer.tokenize(nil)
      assert_tokens tokens, "[]"
    end

    test "handles empty input" do
      tokens = @tokenizer.tokenize("")
      assert_tokens tokens, "[]"
    end

    test "handles plain text without placeholders" do
      text = "The meeting is scheduled for tomorrow."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'The meeting is scheduled for tomorrow.']"
    end

    test "handles single placeholder in text" do
      text = "Event on #date#."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Event on '], [placeholder: '#date#'], [text: '.']"
    end

    test "handles multiple delimiters with single placeholder" do
      text = "Event on ##currentDate#"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Event on #'], [placeholder: '#currentDate#']"
    end

    test "handles multiple placeholders in text" do
      text = "Meeting on #date#, at #time#."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Meeting on '], [placeholder: '#date#'], [text: ', at '], [placeholder: '#time#'], [text: '.']"
    end

    test "handles mixed text with multiple placeholders" do
      text = "#start# - Meeting details: #details# - #end#."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[placeholder: '#start#'], [text: ' - Meeting details: '], [placeholder: '#details#'], [text: ' - '], [placeholder: '#end#'], [text: '.']"
    end

    test "handles invalid placeholders as plain text" do
      text = "This is valid: #x# and not this: #1y#."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'This is valid: '], [placeholder: '#x#'], [text: ' and not this: #1y#.']"
    end

    test "handles incomplete placeholder as plain text" do
      text = "The project started #y - 3 years ago."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'The project started #y - 3 years ago.']"
    end

    test "handles delimiters inside words as plain text" do
      text = "Check hashtag#example for more info."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Check hashtag#example for more info.']"
    end

    test "handles delimiters with valid placeholder" do
      text = "This company is ##number# in the world."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'This company is #'], [placeholder: '#number#'], [text: ' in the world.']"
    end

    test "handles double delimiters without placeholders" do
      text = "Just a hash ## symbols."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Just a hash ## symbols.']"
    end

    test "handles multiple placeholders with mixed delimiters" do
      text = "Delimiters ## and placeholder #date#."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Delimiters ## and placeholder '], [placeholder: '#date#'], [text: '.']"
    end

    test "handles multiple double delimiters with placeholder" do
      text = "Multiple ##double## delimiters."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Multiple #'], [placeholder: '#double#'], [text: '# delimiters.']"
    end

    test "handles mixed valid and invalid placeholders" do
      text = "Valid #validPlaceholder#, but invalid#invalid and #anotherInvalid."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Valid '], [placeholder: '#validPlaceholder#'], [text: ', but invalid#invalid and #anotherInvalid.']"
    end

    test "handles placeholders with combination of letters and numbers" do
      text = "Starting #m1# and ending #d2#."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Starting '], [placeholder: '#m1#'], [text: ' and ending '], [placeholder: '#d2#'], [text: '.']"
    end

    test "handles delimiters at start and end of text" do
      text = "#start# Middle text #end#"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[placeholder: '#start#'], [text: ' Middle text '], [placeholder: '#end#']"
    end

    test "handles text with only delimiters" do
      text = "###"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: '###']"
    end

    test "handles multiple valid and invalid placeholders" do
      text = "#valid1# and invalid #2invalid# plus another #valid2#"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[placeholder: '#valid1#'], [text: ' and invalid #2invalid# plus another '], [placeholder: '#valid2#']"
    end

    test "handles mixed valid placeholders and text with numbers" do
      text = "Number #num1# and text with 123 numbers"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Number '], [placeholder: '#num1#'], [text: ' and text with 123 numbers']"
    end

    test "handles delimiters around placeholder" do
      text = "###placeholder###"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: '##'], [placeholder: '#placeholder#'], [text: '##']"
    end

    test "handles multiple adjacent placeholders" do
      text = "#placeholder1##placeholder2##placeholder3#"
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[placeholder: '#placeholder1#'], [placeholder: '#placeholder2#'], [placeholder: '#placeholder3#']"
    end

    test "handles placeholders with special characters" do
      text = "Text with #special!# placeholder."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Text with #special!# placeholder.']"
    end

    test "handles placeholders with single operation" do
      text = "Text with #m+1# and #y-2# placeholders."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Text with '], [placeholder: '#m+1#'], [text: ' and '], [placeholder: '#y-2#'], [text: ' placeholders.']"
    end

    test "handles placeholders with multiple operations as invalid" do
      text = "Text with #d+3-1# placeholder."
      tokens = @tokenizer.tokenize(text)
      assert_tokens tokens, "[text: 'Text with #d+3-1# placeholder.']"
    end
  end
end
