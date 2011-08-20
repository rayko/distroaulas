class Plan < ActiveRecord::Base
  attr_accessible :name, :careers, :career_ids

  has_many :careers
end
