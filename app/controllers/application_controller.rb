class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    if params[:date]
      if params[:date].blank?
        date = Date.today
      else
        date = Date.parse params[:date]
      end
      @datetime = DateTime.parse("#{date.year}-#{date.month}-#{date.day} #{DateTime.now.strftime('%H:%M')} #{DateTime.now.zone}")
    else
      @datetime = DateTime.now
    end
    @free_spaces = Space.free_spaces :before => @datetime, :after => @datetime.beginning_of_day
  end

  def new_event
    session[:new_event_space_id] = params[:space]
    redirect_to new_event_path
  end

end
