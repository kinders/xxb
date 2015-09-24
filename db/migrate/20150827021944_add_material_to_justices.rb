class AddMaterialToJustices < ActiveRecord::Migration
  def change
    add_column :justices, :material, :text
  end
end
