class CreateExamrooms < ActiveRecord::Migration
  def change
    create_table :examrooms do |t|
      t.references :user, index: true
      t.references :classroom, index: true
      t.references :paper, index: true
      t.datetime :deleted_at
      t.boolean :isactive

      t.timestamps null: false
    end
    add_index :examrooms, :deleted_at
    add_foreign_key :examrooms, :users
    add_foreign_key :examrooms, :classrooms
    add_foreign_key :examrooms, :papers
  end
end
