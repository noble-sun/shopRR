class AddUserAndAnonymousToProductReview < ActiveRecord::Migration[8.0]
  def change
    add_reference :product_reviews, :user, null: false, foreign_key: true
    add_column :product_reviews, :anonymous, :boolean, default: false
    add_column :product_reviews, :comment, :string
  end
end
