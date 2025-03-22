FactoryBot.define do
  factory :product_review do
    association :user
    association :product
    score { 10 }
    comment { "Best of the best" }
  end
end
