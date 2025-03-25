class CreateProductReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :product_reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :score, null: false

      t.timestamps
    end
  end
end
