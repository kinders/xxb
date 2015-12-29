class CreatePaperitems < ActiveRecord::Migration
  def change
    create_table :paperitems do |t|
      t.references :user, index: true
      t.references :paper, index: true
      t.references :practice, index: true
      t.decimal :score
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :paperitems, :deleted_at
    add_foreign_key :paperitems, :users
    add_foreign_key :paperitems, :papers
    add_foreign_key :paperitems, :practices
  end
end
