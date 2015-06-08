class AddStudentToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks, :student, :integer
  end
end
