class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def index
    if params[:space_type] && !params[:space_type].blank?
      @spaces = Space.find :all, :conditions => { :space_type_id => params[:space_type]}
    else
      @spaces = Space.all
    end
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
    session[:new_event_date] = params[:date]
    redirect_to new_event_path
  end

end
