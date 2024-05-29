# frozen_string_literal: true

module DateVariableParserV2
  class Token < Data.define(:type, :value)
    def to_s
      "[#{type}: '#{value}']"
    end
  end
end
