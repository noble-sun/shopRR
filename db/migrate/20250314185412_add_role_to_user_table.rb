class AddRoleToUserTable < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, null: false, default: 'buyer'
  end
end
