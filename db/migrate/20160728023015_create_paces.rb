class CreatePaces < ActiveRecord::Migration
  def change
    create_table :paces do |t|
      t.references :user, index: true
      t.references :roadmap, index: true
      t.references :lesson, index: true
      t.decimal :serial
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :paces, :deleted_at
    add_foreign_key :paces, :users
    add_foreign_key :paces, :roadmaps
    add_foreign_key :paces, :lessons
  end
end
