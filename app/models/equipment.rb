class Equipment < ActiveRecord::Base
  attr_accessible :name, :description, :equipment_events

  has_many :equipment_events


  validates :name, :presence => true

  def remove_event data
    hours = data[:hours].split('-')
    date = data[:date]
    dtstart = Time.parse "#{date} #{hours[0]}"
    dtend = Time.parse "#{date} #{hours[1]}"
    event = EquipmentEvent.find :first, :conditions => { :dtstart => dtstart, :dtend => dtend, :id => data[:event_id] }
    result = event.delete
    if result
      return true
    else
      return false
    end
  end

  private
  def time_to_rfc time, without_tzid=false
    if without_tzid
      time.strftime "%Y%m%dT%H%M00"
    else
      time.strftime "TZID=#{Rails.configuration.time_zone}:%Y%m%dT%H%M00"
    end
  end


end
