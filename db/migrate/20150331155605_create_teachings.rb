class CreateTeachings < ActiveRecord::Migration
  def change
    create_table :teachings do |t|
      t.references :user, index: true
      t.references :lesson, index: true
      t.string :title

      t.timestamps null: false
    end
    add_foreign_key :teachings, :users
    add_foreign_key :teachings, :lessons
  end
end
