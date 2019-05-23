FactoryBot.define do
  factory :variant do
    name { Faker::Hipster.unique.sentence(5, true, 3) }
    cost { Faker::Number.number(2) }
    stock_amount { Faker::Number.digit }
    weight { Faker::Number.decimal }
    product { Product.first || create(:product) }
  end
end
