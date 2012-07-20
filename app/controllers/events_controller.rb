class EventsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:generate_calendar, :calendar_preview, :tip_summary, :search, :get_responsibles_list]

  def index
    if params[:calendar]
      @events = Event.paginate(:page => params[:page], :conditions => { :calendar_id => params[:calendar]})
    else
      @events = Event.paginate(:page => params[:page])
    end
  end

  def show
    @event = Event.find(params[:id])
    @date = (params[:month] ? Date.parse(params[:month]) : Date.today)
  end

  def new
    @event = Event.new
    if session[:new_event_space_id]
      @event.space_id = session[:new_event_space_id]
    end
  end

  def create
    @event = Event.new(params[:event])
    @event.plan = params[:event][:plan]
    @event.career = params[:event][:career]
    @event.start_date = Date.parse(params[:event][:start_date]) unless params[:event][:start_date].blank?
    if @event.save
      if session[:new_event_space_id]
        session.delete :new_event_space_id
      end
      if session[:new_event_date]
        session.delete :new_event_date
      end
      redirect_to @event, :notice => show_notice(:create_success)
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    # @event.byday = @event.byday.split(',')
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to @event, :notice  => show_notice(:update_success)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, :notice => show_notice(:destroy_success)
  end

  def generate_calendar
    if request.post?
      #clean up params to send to model
      params[:search].delete :plan
      if params[:search][:recurrent] == "1"
        params[:search][:recurrent] = true
      else
        params[:search].delete :recurrent
      end
      # search events with criteria
      @events = Event.search_events clean_params(params[:search])
    end
  end

  def calendar_preview
    # show events in weekly view with criteria
    if params[:display_options][:display_title] == '1'
      @title = params[:display_options][:title]
    end
    if !params[:display_options][:date].blank?
      @date = Date.parse params[:display_options][:date]
    else
      @date = Date.today
      until @date.monday?
        @date -= 1.days
      end
    end
=begin
    @hours = [params[:display_options][:start_hour].to_i, params[:display_options][:end_hour].to_i].uniq
    if !@hours.empty?
      @width = 145 + (@hours[1] - @hours[0]) * 75 + 75
      if @width > 972
        @with = 972
      end
    end
=end
    @display_options = clean_params(params[:display_options])
    @events = Event.find :all, :conditions => { :id => params[:events_ids]}
    @events.collect{ |event| event.rical_occurrences(:after => @date, :before => (@date + 7.days)) }
  end


  def tip_summary
    @event = Event.find(params[:id])
    render :action => 'tip_summary', :layout => false
  end

  def search
    @events = Event.all
    render :partial => 'events/search_result', :locals => { :events => @events}
  end

  def get_responsibles_list
    list = Event.responsibles_list
    respond_to do |format|
      format.json { render :json => list.to_json, :status => 200}
    end
  end

  private
  def clean_params p=nil
    p.delete_if{ |key, value| value.blank? }
  end
end

