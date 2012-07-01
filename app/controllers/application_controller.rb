class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => show_alert(:permission_denied) # exception.message
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

  private
  def get_controller_name
    if params[:controller].include? '/'
      params[:controller].gsub '/', '.'
    else
      params[:controller]
    end
  end


  # Gets notice texts from I18n library
  def show_notice n, attrs={}
    return t ['controllers', get_controller_name, 'notices', n.to_s].join('.'), attrs
  end

  # Gets alert texts from I18n library
  def show_alert a, attrs={}
    return t ['controllers', get_controller_name, 'alerts', a.to_s].join('.'), attrs
  end


end
