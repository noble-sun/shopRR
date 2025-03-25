FactoryBot.define do
  factory :cart do
    status { 'active' }
    association :user
    order { nil }
  end
end
