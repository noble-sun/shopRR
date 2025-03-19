class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :product_review, null: false, foreign_key: true
      t.string :body, null: false

      t.timestamps
    end
  end
end
