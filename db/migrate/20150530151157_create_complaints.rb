class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.references :user, index: true
      t.string :url
      t.text :content
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :complaints, :deleted_at
    add_foreign_key :complaints, :users
  end
end
