class AddSubjectIdToTeacher < ActiveRecord::Migration
  def change
    add_reference :teachers, :subject, index: true
    add_foreign_key :teachers, :subjects
  end
end
