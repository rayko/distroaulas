FactoryGirl.define do
  factory :matter do
    career
    sequence :name do |n|
      "Matter #{n}"
    end

    sequence :short_name do |n|
      "M#{n}"
    end

    year '1'
    responsible 'Lolcat'
  end
end
