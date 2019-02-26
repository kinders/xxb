class AddCountToWords < ActiveRecord::Migration[5.0]
  def change
    add_column :words, :phonetics_count, :integer, default: 0
    add_column :words, :meanings_count, :integer, default: 0
  end
end
