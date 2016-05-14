class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name
      t.integer :length
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :words, :name
    add_index :words, :deleted_at
  end
end
