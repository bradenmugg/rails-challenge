FactoryBot.define do
  factory :product do
    name { Faker::Hipster.unique.sentence(5, true, 3) }
  end
end
