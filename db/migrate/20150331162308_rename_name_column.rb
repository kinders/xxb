class RenameNameColumn < ActiveRecord::Migration
  def change
    rename_column :lessons, :name, :title
  end
end
