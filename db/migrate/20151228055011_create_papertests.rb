class CreatePapertests < ActiveRecord::Migration
  def change
    create_table :papertests do |t|
      t.references :user, index: true
      t.references :paper, index: true
      t.datetime :end_at
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :papertests, :deleted_at
    add_foreign_key :papertests, :users
    add_foreign_key :papertests, :papers
  end
end
