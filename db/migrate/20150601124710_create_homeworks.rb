class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.references :user, index: true
      t.references :classroom, index: true
      t.string :subject
      t.string :title
      t.text :description
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :homeworks, :deleted_at
    add_foreign_key :homeworks, :users
    add_foreign_key :homeworks, :classrooms
  end
end
