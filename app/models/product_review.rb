class ProductReview < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :score, presence: true, numericality: {
    only_integer: true, in: 1..10
  }
end
