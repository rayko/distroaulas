class Calendar < ActiveRecord::Base
  attr_accessible :name, :career, :career_id, :events, :event_ids

  belongs_to :career
  has_many :events
end
