class AddPracticeScoreToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :practice_score, :decimal
  end
end
