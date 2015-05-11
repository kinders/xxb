class AddStudentToMember < ActiveRecord::Migration
  def change
    add_column :members, :student, :integer
  end
end
