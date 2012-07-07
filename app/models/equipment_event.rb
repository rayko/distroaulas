class EquipmentEvent < ActiveRecord::Base

  attr_accessible :dtstart, :dtend, :event_id, :space_id, :equipment_id, :event, :space, :equipment

  belongs_to :event
  belongs_to :space
  belongs_to :equipment

  def self.create_events events=[]
    # Create one or more events with given data
    events_created = []
    events.each do |event|
      event[:dtstart] = time_to_rfc(event[:dtstart])
      event[:dtend] = time_to_rfc(event[:dtend])
      events_created << self.create(event)
    end
    return events_created
  end

  private
  def self.time_to_rfc time, without_tzid=false
    if without_tzid
      time.strftime "%Y%m%dT%H%M00"
    else
      time.strftime "TZID=#{Rails.configuration.time_zone}:%Y%m%dT%H%M00"
    end
  end
end
