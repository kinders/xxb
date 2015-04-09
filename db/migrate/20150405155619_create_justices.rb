class CreateJustices < ActiveRecord::Migration
  def change
    create_table :justices do |t|
      t.decimal :score, null: false
      t.text :remark
      t.boolean :activity, default: true
      t.references :user, index: true
      t.references :evaluation, index: true

      t.timestamps null: false
    end
    add_foreign_key :justices, :users
    add_foreign_key :justices, :evaluations
  end
end
