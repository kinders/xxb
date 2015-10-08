class AddShareToCardboxes < ActiveRecord::Migration
  def change
    add_column :cardboxes, :share, :boolean, default: false
  end
end
