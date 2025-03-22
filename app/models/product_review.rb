class ProductReview < ApplicationRecord
  belongs_to :product

  validates :score, presence: true, numericality: {
    only_integer: true, in: 1..10
  }
end
