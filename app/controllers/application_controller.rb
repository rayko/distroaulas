class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    if params[:date]
      @date = Date.parse("#{params[:date][:year]}-#{params[:date][:month]}-#{params[:date][:day]}")
    else
      @date = Date.today
    end
  end

end
