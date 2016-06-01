class AddTimeToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :time, :integer
  end
end
