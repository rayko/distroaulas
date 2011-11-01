class Matter < ActiveRecord::Base
  attr_accessible :name, :short_name, :career_id, :year, :career, :events,
                  :event_ids

  belongs_to :career

  has_many :events

  def occurrences options={}
    until_date = options[:before] || Date.today + 5.years
    after_date = options[:after] || Date.new
    occurrences = []
    events = Event.find :all, :conditions => {:matter_id => self.id}
    events.each do |event|
      occurrences << event.to_rical.occurrences(:starting => after_date, :before => until_date)
    end
    return occurrences.flatten
  end
end
