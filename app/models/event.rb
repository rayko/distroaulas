class Event < ActiveRecord::Base
  attr_accessible :name, :matter, :matter_id, :space, :space_id, :calendar,
                  :calendar_id, :dtstart, :dtend, :exdate, :rdate, :recurrent,
                  :freq, :interval, :until_date, :byday, :count, :plan, :career,
                  :start_date, :start_time, :end_time, :responsible, :days_of_recurr,
                  :plan, :career

  # Virtual attributes for easy creation
  attr_accessor :plan, :career, :days_of_recurr

  before_validation :fill_date_fields

  belongs_to :matter
  belongs_to :space
  belongs_to :calendar
  belongs_to :plan
  belongs_to :career

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
  validates_with StartDateValidator, :on => :create
  validates_with UntilDateValidator

  require 'reccurrence_rule'

  def career
    self.matter.career if self.matter
  end

  def plan
    self.matter.career.plan if self.matter
  end

  def plan_id
    self.plan.id if self.matter
  end

  def career_id
    self.career.id if self.matter
  end

  # Returns a RiCal Event with the data on the event object
  def to_rical
    event = RiCal.Event
    event.dtstart = self.dtstart_to_rfc
    event.dtend = self.dtend_to_rfc

    # Custom value added to RiCal Event Component
    event.space = self.space
    if self.rdate
      event.add_rdates self.rdate.split(',').collect{ |date| time_to_rfc(DateTime.parse("#{date} #{self.dtstart.strftime('%H:%M')} #{DateTime.now.zone}"))}
    end
    if self.exdate
      event.add_exdates self.exdate.split(',').collect{ |date| time_to_rfc(DateTime.parse("#{date} #{self.dtstart.strftime('%H:%M')} #{DateTime.now.zone}"))}
    end
    if self.recurrent
      ReccurrenceRule.new(self.reccurrence_values).load_rule(event)
    end

    # Added DB record to keep track of the event
    event.related_object = self
    return event
  end

  def self.responsibles_list
    Event.all.collect{ |event| event.responsible }.uniq
  end

  def self.expired_events_count
    self.where(['dtend < ? AND recurrent = ?', DateTime.now, false]).size + self.where(['recurrent = ? AND until_date < ?', true, DateTime.now]).size
  end

  def self.with_matters_count
    self.where(['matter_id NOT ?', nil]).size
  end

  def self.free_events_count
    self.where(:matter_id => nil).size
  end

  def self.with_spaces_count
    self.where(['space_id NOT ?', nil]).size
  end



  def self.search_events(options={})
    if options[:career_id]
      matter_ids = Matter.find(:all, :conditions => { :career_id => options[:career_id]}).collect{ |matter| matter.id }
      options.delete :career_id
      options[:matter_id] = matter_ids
    end
    events = Event.where options

    return events

    # Event.find :all, :conditions => ["matter_id IN ? AND responsable = ? AND recurrent = ?", matter_ids, options[:responsable], options[:recurrent], ]
  end

  def name_with_options options={}
    name = []
    name << case options[:display_event_name]
            when 'display'
              self.name
            end
    if self.matter
      name << case options[:display_matter_name]
              when 'full'
                self.matter.name
              when 'short'
                self.matter.short_name
              end
    end
    if self.space
      name << case options[:display_space_name]
              when 'full'
                self.space.name
              when 'short'
                self.space.short_name
              end
    end
    name << case options[:display_time]
            when 'display'
              "#{self.dtstart.strftime('%H:%M')}-#{self.dtend.strftime('%H:%M')}"
            end

    return name.compact.join ' ,'
  end

  def rical_occurrences options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    occurrences = []
    occurrences << self.to_rical.occurrences(:starting => after_date, :before => until_date)
    return occurrences.flatten
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
      time.strftime "TZID=#{Rails.configuration.time_zone}:%Y%m%dT%H%M00"
    end
  end

  def fill_date_fields
    unless self.start_time.blank? or self.start_date.blank? or self.end_time.blank?
      self.dtstart = DateTime.parse "#{self.start_date.strftime('%Y-%m-%d')} #{self.start_time.strftime('%H:%M')} #{DateTime.now.zone}"
      self.dtend = DateTime.parse "#{self.start_date.strftime('%Y-%m-%d')} #{self.end_time.strftime('%H:%M')} #{DateTime.now.zone}"
    end
  end
end


