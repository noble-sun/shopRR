class ProductReview < ApplicationRecord
  belongs_to :product

  has_many :comments

  validates :score, presence: true, numericality: {
    only_integer: true, in: 1..10
  }
end
