class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :user, index: true
      t.references :sectionalization, index: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :teams, :deleted_at
    add_foreign_key :teams, :users
    add_foreign_key :teams, :sectionalizations
  end
end
