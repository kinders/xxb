class AddSourceToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :source, :string
  end
end
