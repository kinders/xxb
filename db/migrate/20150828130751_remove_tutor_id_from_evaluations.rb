class RemoveTutorIdFromEvaluations < ActiveRecord::Migration
  def change
    remove_reference :evaluations, :tutor, index: true
    remove_foreign_key :evaluations, :tutors
  end
end
