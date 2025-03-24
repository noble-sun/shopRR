# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(
  email_address: 'seller@email.com',
  cpf: '70502565012',
  password: 'Senha@123',
  name: 'John',
  surname: 'Titor',
  phone: '11987654321',
  date_of_birth: '31/12/1999',
  active: true,
  admin: false,
  role: 'seller'
)

Product.create!(user:, name: "Cat", description: "A baby cat", quantity: 10, price: 0.1).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/spec/support/images/cat.jpg"), filename: 'a cat')
end

Product.create!(user:, name: "Dog", description: "A baby dog", quantity: 10, price: 0.1).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/spec/support/images/dog.jpg"), filename: 'a cat')
end

require "#{Rails.root.join("spec/support/factory_helpers")}"
buyer = User.create!(
  email_address: 'buyer@email.com',
  cpf: FactoryHelpers.generate_cpf,
  password: 'Senha@123',
  name: 'Merry',
  surname: 'Kakimiya',
  phone: '11987654321',
  date_of_birth: '31/12/1999',
  active: true,
  admin: false,
  role: :buyer
)

address = Address.create!(
  user: buyer,
  street: "St. One",
  number: 101,
  neighborhood: "Frontier",
  city: "Alterna",
  state: "Arabakia",
  zipcode: "1000010",
  country: "Grimgar",
  primary_address: true
)
