FactoryBot.define do
  factory :area do
    name { Faker::FunnyName.name }
    test_exception { '1' }
    company
  end
end
