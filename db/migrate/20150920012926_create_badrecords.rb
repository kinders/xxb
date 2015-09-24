class CreateBadrecords < ActiveRecord::Migration
  def change
    create_table :badrecords do |t|
      t.references :user, index: true
      t.integer :troublemaker
      t.references :classroom, index: true
      t.datetime :troubletime
      t.references :subject, index: true
      t.text :description
      t.boolean :finish
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :badrecords, :deleted_at
    add_foreign_key :badrecords, :users
    add_foreign_key :badrecords, :classrooms
    add_foreign_key :badrecords, :subjects
  end
end
