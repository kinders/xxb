class AddMdToWord < ActiveRecord::Migration
  def change
    add_column :words, :md1, :integer
    add_index :words, :md1
    add_column :words, :md2, :integer
    add_index :words, :md2
    add_column :words, :md3, :integer
    add_index :words, :md3
    add_column :words, :md4, :integer
    add_index :words, :md4
    add_column :words, :is_meanful, :boolean
    remove_index :words, :name
  end
end
