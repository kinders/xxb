class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :title, null: false
      t.decimal :difficulty, null: false
      t.text :page, null: false
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :tutors, :users
  end
end
