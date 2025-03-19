class ProductReview < ApplicationRecord
  belongs_to :product

  has_many :comments
end
