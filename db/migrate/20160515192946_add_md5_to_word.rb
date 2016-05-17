class AddMd5ToWord < ActiveRecord::Migration
  def change
    add_column :words, :md5, :integer
    add_index :words, :md5
    add_column :words, :md6, :integer
    add_index :words, :md6
    add_column :words, :md7, :integer
    add_index :words, :md7
    add_column :words, :md8, :integer
    add_index :words, :md8
  end
end
