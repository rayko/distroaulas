class Event < ActiveRecord::Base
  attr_accessible :name, :matter, :matter_id, :space, :space_id, :calendar,
                  :calendar_id, :dtstart, :dtend, :exdate, :rdate, :recurrent,
                  :freq

  belongs_to :matter
  belongs_to :space
  belongs_to :calendar

  require 'ri_cal'

  def to_rical
    event = RiCal.Event
    event.dtstart = self.dtstart_to_rfc
    event.dtend = self.dtend_to_rfc
    return event
  end

  def dtstart_to_rfc
    time_to_rfc self.dtstart
  end

  def dtend_to_rfc
    time_to_rfc self.dtend
  end

  private
  def time_to_rfc time
    time.strftime "TZID=America/Buenos_Aires:%Y%m%dT%H%M00"
  end
end
