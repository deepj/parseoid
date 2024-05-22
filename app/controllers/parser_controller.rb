# frozen_string_literal: true

class ParserController < ApplicationController
  def show
  end

  def preview
    @content = params[:content].presence || "Textual magic loading... Preview to enchant shortly."
    @date = helpers.date_from_param(params[:date])

    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end
end
