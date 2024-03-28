# frozen_string_literal: true

module ParserHelper
  def render_date_template(template, date)
    parser = DateVariableParser::DateParser.new
    parser.parse(template.presence || "Textual magic loading... Preview to enchant shortly.", date || Date.current)
  end
end
