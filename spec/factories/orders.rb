FactoryBot.define do
  factory :order do
    association(:user)
    address { nil }
    status { "pending" }
  end
end
