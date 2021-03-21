FactoryBot.define do
  factory :owner do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.hex(20) }
    company_name { Faker::Company.name }
    public_key { SecureRandom.hex(20) }

    frontend
  end
end
