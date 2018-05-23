FactoryGirl.define do
  factory :post do
    association :poster
    latitude 40.444832
    longitude -79.947758
    number_people 1
    street_1 "4615 Forbes Ave"
    zip "15213"
    city "Pittsburgh"
    state "PA"
    date_posted DateTime.current
  end

  factory :user_post do
    association :user
    association :post
  end
  
  factory :user do
    job_title "worker"
    association :organization
    first_name "Ed"
    last_name "Gruberman"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    email { |u| "#{u.first_name[0]}#{u.last_name}#{(1..99).to_a.sample}@example.com".downcase }
    sequence :username do |n|
      "user#{n}"
    end
    password "secret"
    password_confirmation "secret"
    role "worker"
    active true
  end

  factory :organization do
    name "Pittsburgh Social Workers"
    active true
  end

  factory :need do
    name "Food"
  end

  factory :post_need do
      association :need
      association :post
  end


end