class CreateCadres < ActiveRecord::Migration
  def change
    create_table :cadres do |t|
      t.references :user, index: true
      t.string :position
      t.references :member, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_foreign_key :cadres, :users
    add_foreign_key :cadres, :members
  end
end
