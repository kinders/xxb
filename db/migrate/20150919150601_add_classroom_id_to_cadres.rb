class AddClassroomIdToCadres < ActiveRecord::Migration
  def change
    add_reference :cadres, :classroom, index: true
    add_foreign_key :cadres, :classrooms
  end
end
