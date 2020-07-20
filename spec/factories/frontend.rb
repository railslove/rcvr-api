FactoryBot.define do
  factory :frontend do
    url { Faker::Internet.url }
    name { Faker::Company.name }

    trait :care do
      url { 'https://care.rcvr.app' }
    end
  end
end
