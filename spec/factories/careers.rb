FactoryGirl.define do
  factory :career do
    plan
    sequence :name do |n|
      "Career #{n}"
    end
    sequence :short_name do |n|
      "C#{n}"
    end
  end
end
