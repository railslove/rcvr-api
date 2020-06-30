FactoryBot.define do
  factory :frontend do
    url { Faker::Internet.url }
    name { Faker::Company.name }
  end
end
