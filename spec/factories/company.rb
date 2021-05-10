FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    street { Faker::Address.street_address }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
    location_type { :food_service }
    owner
  end
end
