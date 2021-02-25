FactoryBot.define do
  factory :ticket do
    id { Faker::Internet.uuid }
    entered_at { Faker::Time.between(from: 2.hours.ago, to: 1.hour.ago) }
    left_at { Faker::Time.between(from: 1.hour.ago, to: Time.zone.now - 1.minute) }
    encrypted_data {Faker::Alphanumeric.alphanumeric}
    area

    trait :open do
      left_at { nil }
    end
  end
end
