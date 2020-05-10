FactoryBot.define do
  factory :area do
    name { Faker::FunnyName.name }

    company
  end
end
