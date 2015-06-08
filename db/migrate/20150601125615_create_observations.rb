class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.references :user, index: true
      t.integer :student
      t.string :point
      t.text :mark
      t.datetime :deleted_at
      t.references :homework, index: true

      t.timestamps null: false
    end
    add_index :observations, :deleted_at
    add_foreign_key :observations, :users
    add_foreign_key :observations, :homeworks
  end
end
