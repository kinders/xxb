class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.references :user, index: true
      t.references :classroom, index: true
      t.integer :mentor
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :teachers, :deleted_at
    add_foreign_key :teachers, :users
    add_foreign_key :teachers, :classrooms
  end
end
