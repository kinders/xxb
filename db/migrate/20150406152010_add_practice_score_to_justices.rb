class AddPracticeScoreToJustices < ActiveRecord::Migration
  def change
    add_column :justices, :practice_score, :decimal
  end
end
