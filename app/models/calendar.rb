class Calendar < ActiveRecord::Base
  attr_accessible :name, :career, :career_id, :events, :event_ids

  belongs_to :career
  has_many :events

  require 'ri_cal'

  def to_rical
    calendar = RiCal.Calendar
    self.events.each do |event|
      calendar.add_subcomponent event.to_rical
    end
    return calendar
  end

  def occurrences options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    occurrences = []
    self.events.each do |event|
      occurrences << event.to_rical.occurrences(:starting => after_date, :before => until_date)
    end
    return occurrences.flatten
  end
end
