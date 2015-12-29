class AddEndAtToEvaluation < ActiveRecord::Migration
  def change
    add_column :evaluations, :end_at, :datetime
  end
end
