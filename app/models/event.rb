class Event < ActiveRecord::Base
  attr_accessible :name, :matter, :matter_id, :space, :space_id, :calendar,
                  :calendar_id

  belongs_to :matter
  belongs_to :space
  belongs_to :calendar
end
