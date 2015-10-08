class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :user, index: true
      t.references :practice, index: true
      t.references :cardbox, index: true
      t.decimal :serial
      t.integer :degree, default: 0
      t.datetime :nexttime
      t.integer :foul, default: 0
      t.integer :count, default: 0
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :cards, :deleted_at
    add_foreign_key :cards, :users
    add_foreign_key :cards, :practices
    add_foreign_key :cards, :cardboxes
  end
end
