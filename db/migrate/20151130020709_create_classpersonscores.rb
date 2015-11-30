class CreateClasspersonscores < ActiveRecord::Migration
  def change
    create_table :classpersonscores do |t|
      t.references :user, index: true
      t.references :member, index: true
      t.decimal :score
      t.references :classgroupscore, index: true
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :classpersonscores, :deleted_at
    add_foreign_key :classpersonscores, :users
    add_foreign_key :classpersonscores, :members
    add_foreign_key :classpersonscores, :classgroupscores
  end
end
