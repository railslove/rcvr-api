FactoryBot.define do
  factory :owner do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    company_name { Faker::Company.name }
    phone { Faker::PhoneNumber.phone_number }
    street { Faker::Address.street_address }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
    password { SecureRandom.hex(20) }

    public_key { SecureRandom.hex(20) }

    frontend
  end
end
