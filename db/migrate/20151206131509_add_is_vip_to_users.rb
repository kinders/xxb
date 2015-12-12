class AddIsVipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_vip, :boolean
    add_index :users, :is_vip
  end
end
