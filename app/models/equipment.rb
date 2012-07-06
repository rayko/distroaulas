class Equipment < ActiveRecord::Base
  attr_accessible :name, :description, :equipment_events

  has_many :equipment_events

end
