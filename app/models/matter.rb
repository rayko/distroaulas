class Matter < ActiveRecord::Base
  attr_accessible :name, :short_name, :career_id, :year, :career, :events,
                  :event_ids

  belongs_to :career

  has_many :events
end
