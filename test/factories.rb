FactoryGirl.define do
  factory :post do
    name "Vinyl Chess Board - Green & White"
    description "These Vinyl Chess Boards are just what their name implies - a good basic chess board which meets all tournament standards. Board measures 20x20 inches with 2.25 inch square and all boards have clear and legible algebraic notation."
    # picture nil
    color "green/white"
    category "boards"
    weight 0.5
    inventory_level 100
    reorder_level 25
    active true
  end

  factory :user_post do
    association :user
    association :post
  end
  
  factory :user do
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

  factory :school do
    name "Central Catholic High School"
    street_1 "4720 Fifth Avenue"
    street_2 nil
    city "Pittsburgh"
    state "PA"
    zip "15213"
    min_grade 9
    max_grade 12
    active true
  end

  factory :order do
    date Date.current
    association :school
    association :user
    grand_total 0.00
    credit_card_number "4123456789012345"
    expiration_year 1.year.from_now.year
    expiration_month 12
    payment_receipt nil
  end

  factory :order_item do
    shipped_on nil
    association :order
    association :item
    quantity 1
  end

  factory :purchase do
    association :item
    quantity 1
    date Date.current
  end

end