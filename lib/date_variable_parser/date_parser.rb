# frozen_string_literal: true

module DateVariableParser
  class DateParser
    DATE_PARTS = %i[day month year].freeze

    def initialize(tokenizer = DateTokenizer.new)
      @tokenizer = tokenizer
    end

    def parse(text, date)
      tokens = @tokenizer.tokenize(text)
      result = +""

      tokens.each do |token|
        result << case token.type
        when :text
          process_text(token.value)
        when :date_segment
          process_date_segment(token.value, date)
        else
          "" # For unknown token types, additional logic can be added here
        end
      end

      result
    end

    private

    attr_reader :tokenizer

    def process_text(text)
      text
    end

    # Processes a date_segment and returns a modified string
    def process_date_segment(date_parts, base_date)
      date_part_positions = { day: nil, month: nil, year: nil }
      date_part_values = { day: 0, month: 0, year: 0 }

      # Extract and update information about date_part
      date_parts.each_with_index do |date_part, index|
        type = date_part.type
        next unless DATE_PARTS.include?(type)

        date_part_positions[type] ||= index
        date_part_values[type] += date_part.value.to_i
      end

      modified_date = base_date.advance(days: date_part_values[:day], months: date_part_values[:month], years: date_part_values[:year])

      # Updates the values in date_parts based on the modified date
      update_date_parts(date_parts, date_part_positions, modified_date)

      date_parts.map(&:value).join
    end

    def update_date_parts(date_parts, date_part_positions, modified_date)
      date_part_positions.each do |type, position|
        next unless position

        date_parts[position] = Token.new(:text, modified_date.public_send(type).to_s)
      end
    end
  end
end
