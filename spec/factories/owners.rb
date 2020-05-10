FactoryBot.define do
  factory :owner do
    email { Faker::Internet.email }
    password { SecureRandom.hex(20) }
  end
end
