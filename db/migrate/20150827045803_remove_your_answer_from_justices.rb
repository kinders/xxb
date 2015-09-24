class RemoveYourAnswerFromJustices < ActiveRecord::Migration
  def change
    remove_column :justices, :your_answer, :text
  end
end
