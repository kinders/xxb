class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.references :user, index: true
      t.string :title
      t.integer :duration
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :papers, :deleted_at
    add_foreign_key :papers, :users
  end
end
