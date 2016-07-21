class AddAuthorToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :author, :string
    add_index :lessons, :author
  end
end
