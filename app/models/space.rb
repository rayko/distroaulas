class Space < ActiveRecord::Base
  attr_accessible :name, :short_name, :description, :capacity, :space_type_id,
                  :events, :event_ids, :space_type

  belongs_to :space_type

  has_many :events
end
