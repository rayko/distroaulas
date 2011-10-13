class Space < ActiveRecord::Base
  attr_accessible :name, :short_name, :description, :capacity, :space_type_id,
                  :events, :event_ids, :space_type

  belongs_to :space_type

  has_many :events

  def rical_events
    events = []
    self.events.each do |event|
      events << event.to_rical
    end
    return events
  end

  def rical_occurrences options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    occurrences = []
    self.events.each do |event|
      occurrences << event.to_rical.occurrences(:starting => after_date, :before => until_date)
    end
    return occurrences.flatten
  end
end
