class AddEvaluationUserIdToJustices < ActiveRecord::Migration
  def change
    add_column :justices, :evaluation_user_id, :integer
  end
end
