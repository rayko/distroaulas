class Event < ActiveRecord::Base
  attr_accessible :name, :matter, :matter_id, :space, :space_id, :calendar,
                  :calendar_id, :dtstart, :dtend, :exdate, :rdate, :recurrent,
                  :freq, :interval, :until_date, :byday, :count, :plan, :career,
                  :start_date, :start_time, :end_time

  # Virtual attributes for easy creation
  attr_accessor :plan, :career

  before_validation :fill_date_fields

  belongs_to :matter
  belongs_to :space
  belongs_to :calendar

  validates :calendar, :presence => true
  validates :name, :presence => true
  validates :dtstart, :presence => true
  validates :dtend, :presence => true

  validates :start_date, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true

  # Custom validations
  require 'event_validations'
  include EventCustomValidations

  validates_with PeriodValidator
  validates_with StartDateValidator

  require 'reccurrence_rule'

  # Returns a RiCal Event with the data on the event object
  def to_rical
    event = RiCal.Event
    event.dtstart = self.dtstart_to_rfc
    event.dtend = self.dtend_to_rfc

    # Custom value added to RiCal Event Component
    event.space = self.space
    if self.recurrent
      ReccurrenceRule.new(self.reccurrence_values).load_rule(event)
    end

    # Added DB record to keep track of the event
    event.related_object = self
    return event
  end

  # Returns an instance of ReccurrenceRule with the parameters on the event object
  def reccurrence_rule
    ReccurrenceRule.new(self.reccurrence_values)
  end

  # Returns a hash with the reccurrence parameters for the RRULE
  def reccurrence_values
    {:frequency => self.freq, :interval => self.interval, :until_date => time_to_rfc(self.until_date, true), :byday => self.byday, :count => self.count}
  end

  # Converts the dtstart value into an RFC date time
  def dtstart_to_rfc
    time_to_rfc self.dtstart
  end

  # Converts the dtend value into an RFC date time
  def dtend_to_rfc
    time_to_rfc self.dtend
  end

  def starts_at
    self.dtstart
  end

  def ends_at
    self.dtend
  end

  private
  # Returns an RFC string time with TZID information
  def time_to_rfc time, without_tzid=false
    if without_tzid
      time.strftime "%Y%m%dT%H%M00"
    else
      time.strftime "TZID=America/Buenos_Aires:%Y%m%dT%H%M00"
    end
  end

  def fill_date_fields
    a = 2-1
    unless self.start_time.blank? or self.start_date.blank? or self.end_time.blank?
      self.dtstart = DateTime.parse "#{self.start_date.strftime('%Y-%m-%d')} #{self.start_time.strftime('%H:%M')} #{DateTime.now.zone}"
      self.dtend = DateTime.parse "#{self.start_date.strftime('%Y-%m-%d')} #{self.end_time.strftime('%H:%M')} #{DateTime.now.zone}"
    end
  end
end


