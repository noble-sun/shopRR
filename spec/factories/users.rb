FactoryBot.define do
  factory :user do
    name { 'Muhammad' }
    surname { 'Wang' }
    sequence(:email_address) { |n| "email#{n}@email.com" }
    cpf { FactoryHelpers.generate_cpf }
    password { 'Pass@123' }
    phone { '11987654321' }
    date_of_birth { '31/12/2000' }
    active { true }
    admin { false }

    trait :seller do
      role { :seller }
    end
  end
end
