class CreateClassgroupscores < ActiveRecord::Migration
  def change
    create_table :classgroupscores do |t|
      t.references :user, index: true
      t.references :team, index: true
      t.decimal :score
      t.string :domain
      t.string :memo
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :classgroupscores, :deleted_at
    add_foreign_key :classgroupscores, :users
    add_foreign_key :classgroupscores, :teams
  end
end
