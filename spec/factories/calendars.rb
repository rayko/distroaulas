FactoryGirl.define do
  factory :calendar do
    career
    sequence :name do |n|
      "Calendar #{n}"
    end
  end
end
