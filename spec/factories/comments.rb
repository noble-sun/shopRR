FactoryBot.define do
  factory :comment do
    product_review { nil }
    body { "MyString" }
  end
end
