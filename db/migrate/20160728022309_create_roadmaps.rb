class CreateRoadmaps < ActiveRecord::Migration
  def change
    create_table :roadmaps do |t|
      t.string :name
      t.text :description
      t.references :user, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :roadmaps, :deleted_at
    add_foreign_key :roadmaps, :users
  end
end
