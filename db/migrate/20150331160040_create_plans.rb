class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.decimal :serail
      t.references :user, index: true
      t.references :teaching, index: true
      t.references :tutor, index: true

      t.timestamps null: false
    end
    add_foreign_key :plans, :users
    add_foreign_key :plans, :teachings
    add_foreign_key :plans, :tutors
  end
end
