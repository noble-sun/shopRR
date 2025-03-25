class AddOrderToCart < ActiveRecord::Migration[8.0]
  def change
    add_reference :carts, :order, foreign_key: true
  end
end
