FactoryBot.define do
  factory :data_request do
    company

    from { Faker::Time.between(from: 3.hours.ago, to: 2.hour.ago) }
    to { Faker::Time.between(from: 1.hour.ago, to: Time.zone.now) }
  end
end
