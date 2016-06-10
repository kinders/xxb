class CreatePhonetics < ActiveRecord::Migration
  def change
    create_table :phonetics do |t|
      t.string :content
      t.string :label
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :phonetics, :deleted_at
  end
end
