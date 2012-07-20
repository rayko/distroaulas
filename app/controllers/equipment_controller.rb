class EquipmentController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:assign_event, :event_info, :create_events, :remove_event, :equipment_events, :new_event, :create_single_event]

  def index
    @equipment = Equipment.paginate(:page => params[:page])
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(params[:equipment])
    if @equipment.save
      redirect_to equipment_index_path, :notice => show_notice(:create_success)
    else
      render :action => 'new'
    end
  end

  def edit
    @equipment = Equipment.find(params[:id])
  end

  def update
    @equipment = Equipment.find(params[:id])
    if @equipment.update_attributes(params[:equipment])
      redirect_to equipment_index_path, :notice  => show_notice(:update_success)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    redirect_to equipment_index_url, :notice => show_notice(:destroy_success)
  end

  def calendar
    if request.post?
      @date = Time.parse params[:date]
    else
      @date = Time.now
    end
    @equipments = Equipment.all
  end

  def assign_event
    authorize! :manage, Equipment
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

  def event_info
    authorize! :manage, Equipment
    @event = Event.find_by_id params[:event_id]
    if params[:date]
      @date = Date.parse params[:date]
    else
      @date = Date.today
    end
    while !@date.monday?
      @date -= 1.day
    end
    render :partial => 'event_info', :locals => { :date => @date, :event => @event }
  end

  def create_events
    authorize! :manage, Equipment
    @equipment = Equipment.find_by_id params[:id]
    events = params[:assign][:occurrences].split(',')
    events_data = []
    events.each do |event|
      event_attr = event.split('||').collect{ |d| d.strip }
      event_id, event_date, event_time = event_attr
      event_time = event_time.split('-')
      event_start = DateTime.parse "#{event_date} #{event_time[0]}"
      event_end = DateTime.parse "#{event_date} #{event_time[1]}"
      events_data << { :dtstart => event_start, :dtend => event_end, :event_id => event_id, :equipment_id => @equipment.id }
    end
    @events = EquipmentEvent.create_events events_data
    @text = I18n.t('equipment.equipment_events.event_list')
    if @events.size != events_data.size
      flash[:notice] = show_notice :assign_success_with_colission
    else
      flash[:notice] = show_notice :assign_success
    end
    render :equipment_events
  end

  def remove_event
    authorize! :manage, Equipment
    @event = EquipmentEvent.find_by_id params[:event_id]
    @event.destroy
    redirect_to equipment_events_equipment_path(params[:id]), :notice => show_notice(:equipment_event_remove_success)

  end

  def equipment_events
    if params[:date]
      @date = Date.parse params[:date]
    else
      @date = Date.today
    end
    while !@date.monday?
      @date -= 1.day
    end
    @equipment = Equipment.find_by_id params[:id]
    @events = @equipment.equipment_events
  end

  def new_event
    authorize! :manage, Equipment
    @equipment_event = EquipmentEvent.new
    @equipment_event.dtstart = DateTime.now
  end

  def create_single_event
    authorize! :manage, Equipment
    params[:equipment_event][:dtstart] = Time.parse "#{params[:equipment_event][:date].gsub('/', '-')} #{params[:equipment_event]['start_hour(4i)']}:#{params[:equipment_event]['start_hour(5i)']}"
    params[:equipment_event][:dtend] = Time.parse "#{params[:equipment_event][:date].gsub('/', '-')} #{params[:equipment_event]['end_hour(4i)']}:#{params[:equipment_event]['end_hour(5i)']}"
    params[:equipment_event].delete 'start_hour(1i)'
    params[:equipment_event].delete 'start_hour(2i)'
    params[:equipment_event].delete 'start_hour(3i)'
    params[:equipment_event].delete 'start_hour(4i)'
    params[:equipment_event].delete 'start_hour(5i)'
    params[:equipment_event].delete 'end_hour(1i)'
    params[:equipment_event].delete 'end_hour(2i)'
    params[:equipment_event].delete 'end_hour(3i)'
    params[:equipment_event].delete 'end_hour(4i)'
    params[:equipment_event].delete 'end_hour(5i)'
    temp = EquipmentEvent.new params[:equipment_event]
    @equipment_event = EquipmentEvent.create_events [params[:equipment_event]]
    if @equipment_event.any?
      redirect_to equipment_events_equipment_path(params[:id]), :notice => show_notice(:create_single_event_success)
    else
      @equipment_event = temp
      flash[:alert] = show_alert :event_colision
      render :action => 'new_event'
    end
  end

  private
  def clean_params p=nil
    p.delete_if{ |key, value| value.blank? }
  end
end
