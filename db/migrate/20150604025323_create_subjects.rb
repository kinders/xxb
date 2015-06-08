class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :subjects, :deleted_at
  end
end
