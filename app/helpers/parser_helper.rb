# frozen_string_literal: true

module ParserHelper
  def date_from_params(param)
    Date.parse(param)
  rescue Date::Error
    nil
  end

  def render_date_template(content, date)
    date = date.presence || Date.current

    parser = DateVariableParser::DateParser.new
    parser.parse(content, date)
  end
end
