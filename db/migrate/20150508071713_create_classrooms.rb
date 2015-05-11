class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string :name
      t.references :user, index: true
      t.boolean :end

      t.timestamps null: false
    end
    add_foreign_key :classrooms, :users
  end
end
