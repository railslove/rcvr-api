FactoryBot.define do
  factory :owner do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.hex(20) }

    public_key { SecureRandom.hex(20) }

    frontend
  end
end
