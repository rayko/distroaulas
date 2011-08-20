class Career < ActiveRecord::Base
  attr_accessible :name, :short_name, :plan, :plan_id, :matters, :matter_ids

  belongs_to :plan
  has_many :matters
end
