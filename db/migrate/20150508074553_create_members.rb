class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.decimal :serial
      t.references :user, index: true
      t.references :classroom, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :members, :deleted_at
    add_foreign_key :members, :classrooms, :users
  end
end
