FactoryBot.define do
  factory :ticket do
    id { Faker::Internet.uuid }
    entered_at { Faker::Date.between(from: 2.hours.ago, to: 1.hour.ago) }
    left_at { Faker::Date.between(from: 1.hour.ago, to: Time.zone.now) }
    area

    trait :open do
      left_at { nil }
    end
  end
end
