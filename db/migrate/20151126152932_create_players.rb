class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :user, index: true
      t.references :team, index: true
      t.references :member, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :players, :deleted_at
    add_foreign_key :players, :users
    add_foreign_key :players, :teams
    add_foreign_key :players, :members
  end
end
