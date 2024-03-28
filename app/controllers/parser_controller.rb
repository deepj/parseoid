# frozen_string_literal: true

class ParserController < ApplicationController
  def show
  end

  def preview
    @content = params[:content]
    @date = Date.parse(params[:date]) rescue nil
puts "Content: #{@content}"
    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end
end
