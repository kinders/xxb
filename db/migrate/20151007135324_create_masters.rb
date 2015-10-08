class CreateMasters < ActiveRecord::Migration
  def change
    create_table :masters do |t|
      t.references :user, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :masters, :deleted_at
    add_foreign_key :masters, :users
  end
end
