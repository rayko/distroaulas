FactoryGirl.define do
  factory :admin, class: User do
    sequence :email do |n|
      "admin#{n}@example.com"
    end
    password '123456'
    password_confirmation '123456'
    sequence :username do |n|
      "test_admin#{n}"
    end

    full_name 'Super Admin'
    role 'admin'
  end

  factory :op, class: User do
    sequence :email do |n|
      "op#{n}@example.com"
    end
    password '123456'
    password_confirmation '123456'
    sequence :username do |n|
      "test_op#{n}"
    end

    full_name 'Operator'
    role 'op'
  end

  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password '123456'
    password_confirmation '123456'
    sequence :username do |n|
      "test_user#{n}"
    end

    full_name 'Regular User'
    role 'user'
  end

end

