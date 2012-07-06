class EquipmentEvent < ActiveRecord::Base

  attr_accessible :dtstart, :dtend, :event_id, :space_id, :equipment_id, :event, :space, :equipment

  belongs_to :event
  belongs_to :space
  belongs_to :equipment

  def self.create_events events=[]
    # Create one or more events with given data
    events_created = []
    events.each do |event|
      events_created << self.create(event)
    end
    return events_created
  end
end
