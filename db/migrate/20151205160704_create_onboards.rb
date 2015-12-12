class CreateOnboards < ActiveRecord::Migration
  def change
    create_table :onboards do |t|
      t.references :user, index: true
      t.datetime :begin_at
      t.datetime :expire_at
      t.datetime :end_at
      t.string :remote_ip
      t.string :http_user_agent
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :onboards, :deleted_at
    add_foreign_key :onboards, :users
  end
end
