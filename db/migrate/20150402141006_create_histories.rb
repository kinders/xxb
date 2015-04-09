class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :user, index: true, null:false
      t.string :modelname, null:false
      t.integer :entryid, null:false

      t.timestamps null: false
    end
    add_foreign_key :histories, :users
  end
end
