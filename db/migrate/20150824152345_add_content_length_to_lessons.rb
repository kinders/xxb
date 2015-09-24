class AddContentLengthToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :content_length, :integer, default: 0
  end
end
