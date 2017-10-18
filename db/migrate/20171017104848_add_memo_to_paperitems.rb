class AddMemoToPaperitems < ActiveRecord::Migration
  def change
    add_column :paperitems, :memo, :text
  end
end
