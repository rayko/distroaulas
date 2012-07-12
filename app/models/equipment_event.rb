class EquipmentEvent < ActiveRecord::Base

  attr_accessible :dtstart, :dtend, :event_id, :space_id, :equipment_id, :event, :space, :equipment, :date, :start_hour, :end_hour, :name

  belongs_to :event
  belongs_to :space
  belongs_to :equipment

  attr_accessor :date, :start_hour, :end_hour

  # before_validation :setup_dates

  def self.create_events events=[]
    # Create one or more events with given data
    events_created = []
    events.each do |event|
      if event[:id]
        event[:name] = Event.find_by_id(event[:event_id]).name
      end
      event[:dtstart] = time_to_rfc(event[:dtstart])
      event[:dtend] = time_to_rfc(event[:dtend])
      new_event = self.new event
      unless collides? new_event
        new_event.save
        events_created << new_event
      end
    end
    return events_created
  end

  def date
    Date.parse(I18n.l(self.dtstart, :format => :short))
  end

  def start_hour
    self.dtstart
  end

  def end_hour
    self.dtend
  end

  def self.collides? event=nil
    events = self.select('dtstart, dtend')
    colision = false
    events.each do |e|
      if event.dtstart.between? e.dtstart, e.dtend
        colision = true
      end
      if event.dtend.between? e.dtstart, e.dtend
        colision = true
      end
    end
    return colision
  end

  def starts_at
    self.dtstart
  end

  def ends_at
    self.dtend
  end

  private
  def setup_dates
    self.dtstart = EquipmentEvent.time_to_rfc(DateTime.parse "#{self.date.gsub('/', '-')} #{self.start_hour}")
    self.dtend = EquipmentEvent.time_to_rfc(DateTime.parse "#{self.date.gsub('/', '-')} #{self.end_hour}")
  end
  def self.time_to_rfc time, without_tzid=false
    if without_tzid
      time.strftime "%Y%m%dT%H%M00"
    else
      time.strftime "TZID=#{Rails.configuration.time_zone}:%Y%m%dT%H%M00"
    end
  end
end
