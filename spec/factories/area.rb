FactoryBot.define do
  factory :area do
    name { Faker::FunnyName.name }
    test_exemption { '1' }
    company
  end
end
