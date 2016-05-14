class CreateWordsReports < ActiveRecord::Migration
  def change
    create_table :words_reports do |t|
      t.references :lesson, index: true
      t.string :md
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :words_reports, :deleted_at
    add_foreign_key :words_reports, :lessons
  end
end
