class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @events = Event.paginate(:page => params[:page])
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
      redirect_to @event, :notice => "Successfully created event."
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.byday = @event.byday.split(',')
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to @event, :notice  => "Successfully updated event."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, :notice => "Successfully destroyed event."
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
    @events = Event.find :all, :conditions => { :id => params[:events_ids]}
    @events.collect{ |event| event.rical_occurrences(:after => Date.today, :before => (Date.today + 7.days)) }
  end


  def tip_summary
    @event = Event.find(params[:id])
    render :action => 'tip_summary', :layout => false
  end

  def search
    @events = Event.all
    render :partial => 'events/search_result', :locals => { :events => @events}
  end

  def get_responsables_list
    list = Event.responsables_list
    respond_to do |format|
      format.json { render :json => list.to_json, :status => 200}
    end
  end

  private
  def clean_params p=nil
    p.delete_if{ |key, value| value.blank? }
  end
end

