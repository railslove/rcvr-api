FactoryBot.define do
  factory :owner do
    email { Faker::Internet.email }
    password { SecureRandom.hex(20) }

    public_key { SecureRandom.hex(20) }

    frontend
  end
end
