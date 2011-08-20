class Event < ActiveRecord::Base
  attr_accessible :name, :matter, :matter_id, :space, :space_id

  belongs_to :matter
  belongs_to :space
end
