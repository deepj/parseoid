# frozen_string_literal: true

module DateVariableParserV2
  class DateTokenizer
    # Character(s) marking the start and end of placeholders, e.g., '#' in "#placeholder#". Currently, only single opening/closing
    # delimiter is supported.
    DELIMITER = "#"

    # Matches placeholders enclosed by DELIMITER. E.g. "#y#", "#m+1#" matches the content including delimiters
    # ?: is used for avoiding creating unnecessary capture groups.
    PLACEHOLDER_REGEX = /#{Regexp.escape(DELIMITER)}([a-zA-Z]+(?:[+-]?\d+)?)#{Regexp.escape(DELIMITER)}/

    # Matches the delimiter character itself. E.g. "#" is matched.
    DELIMITER_REGEX = /#{Regexp.escape(DELIMITER)}/

    # Matches any characters except the DELIMITER. E.g. "#startdate# to #enddate#" matches " to " as plain text between two placeholders.
    TEXT_WITHOUT_DELIMITER_REGEX = /[^#{Regexp.escape(DELIMITER)}]+/

    # Matches the next DELIMITER or the end of text without consuming it. E.g. "##" or "##text#" matches the first '#'. Or end of text.
    # ?= is a positive lookahead assertion matching the delimiter without consuming it.
    NEXT_DELIMITER_OR_END_REGEX = /(?=#{Regexp.escape(DELIMITER)})|\z/

    def tokenize(text)
      return [] if text.blank?

      buffer = +""
      tokens = []
      scanner = StringScanner.new(text)

      until scanner.eos?
        if scanner.scan(PLACEHOLDER_REGEX)
          flush_text_buffer(tokens, buffer)
          buffer = handle_placeholder(scanner, tokens)
        elsif scanner.scan(DELIMITER_REGEX)
          buffer = handle_possible_placeholder(scanner, buffer)
        else
          buffer = handle_text(scanner, buffer)
        end
      end

      # Flush remaining text as the final text token if any.
      flush_text_buffer(tokens, buffer)
      tokens
    end

    private

    # Processes the placeholder match and adds a placeholder token into tokens.
    # E.g., For the input "Message: #date#" => Token.new(:placeholder, "#date#")
    def handle_placeholder(scanner, tokens)
      tokens << Token.new(:placeholder, scanner.matched)
      "" # Empty string for buffer to make it ready for next use.
    end

    # Processes any character and accumulates then as a text into the buffer.
    # E.g., For the input "Message: #date#" => "Message: " is accumulated as plain text.
    def handle_text(scanner, buffer)
      buffer + scanner.scan(TEXT_WITHOUT_DELIMITER_REGEX)
    end

    # Processes DELIMITER characters, looking ahead for a potential placeholder. If not found, accumulates them into the buffer as text.
    # E.g., For "Message: ##date##", two text and one placeholder tokens are generated: "Message #", "#date#", and "#".
    def handle_possible_placeholder(scanner, buffer)
      buffer += scanner.matched
      next_char = scanner.peek(DELIMITER.size)
      if next_char != DELIMITER && !potential_placeholder_ahead?(scanner)
        buffer += scanner.scan_until(NEXT_DELIMITER_OR_END_REGEX)
      end
      buffer
    end

    # Flushes the buffer content as a text token into the tokens list. And then clears the buffer for next use.
    def flush_text_buffer(tokens, buffer)
      tokens << Token.new(:text, buffer) unless buffer.empty?
    end

    # Looks ahead to determine if any valid placeholder follows, without consuming characters.
    def potential_placeholder_ahead?(scanner)
      scanner.exist?(PLACEHOLDER_REGEX)
    end
  end
end
