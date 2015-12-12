class AddActiveTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_time, :integer, default: 0
    add_index :users, :active_time
  end
end
