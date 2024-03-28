# frozen_string_literal: true

module DateVariableParser
  class Token
    attr_reader :type, :value

    def initialize(type, value)
      @type = type
      @value = value.is_a?(Array) ? value.dup : value
    end

    def value=(new_value)
      @value = new_value.is_a?(Array) ? new_value.dup : new_value
    end

    def to_s
      case type
      when :date_segment
        "[#{type}}: [#{value.map(&:to_s).join(', ')}]"
      else
        "[#{type}: '#{value}']"
      end
    end
  end
end
