class AddSerialToPaperitem < ActiveRecord::Migration
  def change
    add_column :paperitems, :serial, :decimal
  end
end
