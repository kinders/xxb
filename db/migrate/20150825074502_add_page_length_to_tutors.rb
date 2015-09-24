class AddPageLengthToTutors < ActiveRecord::Migration
  def change
    add_column :tutors, :page_length, :integer, default: 0
  end
end
