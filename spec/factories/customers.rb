FactoryBot.define do
  factory :customer do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
  end
end
