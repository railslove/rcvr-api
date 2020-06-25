FactoryBot.define do
  factory :affiliate do
    name { Faker::Company.name }
    code { SecureRandom.hex(10) }
    stripe_price_id_monthly { SecureRandom.hex(20) }
  end
end
