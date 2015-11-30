class CreateSectionalizations < ActiveRecord::Migration
  def change
    create_table :sectionalizations do |t|
      t.references :user, index: true
      t.references :classroom, index: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :sectionalizations, :deleted_at
    add_foreign_key :sectionalizations, :users
    add_foreign_key :sectionalizations, :classrooms
  end
end
