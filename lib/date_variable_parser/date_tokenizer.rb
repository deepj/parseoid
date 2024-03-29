# frozen_string_literal: true

module DateVariableParser
  class DateTokenizer
    DATE_PARTS = { "d" => :day, "m" => :month, "y" => :year }.freeze

    def initialize
      @tokens = []
      @buffer = []
      @collected_date_parts = []
    end

    def tokenize(text)
      return tokens unless text

      text.scan(/(#[dmy][+-]?\d*#)|(#[^#]*#?)|([^#]+)/).each do |syntax, invalid_syntax, text|
        handle_syntax(syntax) ||
        handle_text(invalid_syntax || text)
      end

      flush_buffer
      tokens
    end

    private

    attr_accessor :tokens, :buffer, :collected_date_parts

    def handle_syntax(syntax)
      return false unless syntax

      type, modifier = syntax.match(/#([dmy])([+-]?\d*)?#/).captures
      normalized_type = DATE_PARTS[type]

      # If duplicated date part is encountered, it ends token and flush what has been collected so far
      flush_buffer if collected_date_parts.include?(normalized_type)

      buffer << Token.new(normalized_type, modifier.presence || "0")
      collected_date_parts << normalized_type

      true
    end

    def handle_text(text)
      return false unless text

      if !buffer.empty? && buffer.last.type == :text
        buffer.last.value += text
      else
        buffer << Token.new(:text, text)
      end

      true
    end

    def flush_buffer
      if collected_date_parts.any?
        tokens << Token.new(:date_segment, buffer.dup)
      else
        tokens.concat(buffer)
      end

      buffer.clear
      collected_date_parts.clear
    end
  end
end
