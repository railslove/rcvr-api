FactoryBot.define do
  factory :area do
    name { Faker::FunnyName.name }
    test_exemption { true }
    company
  end
end
