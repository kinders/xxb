class CreateWordmaps < ActiveRecord::Migration
  def change
    create_table :wordmaps do |t|
      t.references :user, index: true
      t.references :roadmap, index: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :wordmaps, :deleted_at
    add_foreign_key :wordmaps, :users
    add_foreign_key :wordmaps, :roadmaps
  end
end
