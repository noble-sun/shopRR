class ProductReview < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :score, presence: true, numericality: {
    only_integer: true, in: 1..10
  }

  scope :ordered_reviews_by_user, ->(product) {
    product.product_reviews.order(
      Arel.sql(
        "CASE WHEN user_id = #{Current.user.id} THEN 0 ELSE 1 END, created_at DESC"
      )
    )
  }
end
