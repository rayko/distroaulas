class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @events = Event.all
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
end
