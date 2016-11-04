class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :agreements, :deleted_at
    add_foreign_key :agreements, :users
    add_foreign_key :agreements, :comments
  end
end
