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

Product.create!(user:, name: "Picture of Tiny cat", description: "A baby cat", quantity: 10, price: 1.5).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/spec/support/images/cat.jpg"), filename: 'a cat')
  product.images.attach(io: File.open("#{Rails.root}/public/cat-2.jpg"), filename: 'another cat')
end

Product.create!(user:, name: "Image of Smol Dog", description: "A baby dog", quantity: 10, price: 2.5).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/spec/support/images/dog.jpg"), filename: 'a dog')
  product.images.attach(io: File.open("#{Rails.root}/public/dog-2.jpg"), filename: 'another dog')
  product.images.attach(io: File.open("#{Rails.root}/public/dog-3.jpg"), filename: 'yet another dog')
end

Product.create!(user:, name: "Photo of mini Duck", description: "A baby duck", quantity: 10, price: 10.1).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/public/duck.jpg"), filename: 'a duck')
end

Product.create!(user:, name: "Still of an Otter", description: "A baby otter", quantity: 10, price: 12).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/public/otter.jpg"), filename: 'a otter')
end

Product.create!(user:, name: "Image of a Tiger", description: "A baby tiger", quantity: 10, price: 50).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/public/tiger.jpg"), filename: 'a tiger')
end

Product.create!(user:, name: "Picture of a Polar Bear", description: "A baby polar bear", quantity: 10, price: 250).tap do |product|
  product.images.attach(io: File.open("#{Rails.root}/public/polar-bear.jpg"), filename: 'a polar bear')
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
