class EquipmentEvent < ActiveRecord::Base

  attr_accesible :date, :start_hour, :end_hour, :event_id, :space_id, :equipment_id, :event, :space, :equipment

  belongs_to :event
  belongs_to :space
  belongs_to :equipment

  def create_events events=[]
    # Create one or more events with given data
  end
end
