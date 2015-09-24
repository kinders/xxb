class AddPScoreToJustices < ActiveRecord::Migration
  def change
    add_column :justices, :p_score, :decimal
  end
end
