class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.references :user, index: true
      t.references :classroom, index: true
      t.references :lesson, index: true
      t.references :teaching, index: true
      t.boolean :end
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :discussions, :deleted_at
    add_foreign_key :discussions, :users
    add_foreign_key :discussions, :classrooms
    add_foreign_key :discussions, :lessons
    add_foreign_key :discussions, :teachings
  end
end
