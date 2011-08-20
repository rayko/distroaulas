class Space < ActiveRecord::Base
  attr_accessible :name, :short_name, :description, :capacity, :spacetype_id
end
