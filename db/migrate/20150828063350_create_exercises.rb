class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.references :user, index: true
      t.references :tutor, index: true
      t.decimal :serial
      t.references :practice, index: true

      t.timestamps null: false
    end
    add_foreign_key :exercises, :users
    add_foreign_key :exercises, :tutors
    add_foreign_key :exercises, :practices
  end
end
