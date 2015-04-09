class AddTitleQuestionAnswerYourAnswerToJustices < ActiveRecord::Migration
  def change
    add_column :justices, :title, :string
    add_column :justices, :question, :text
    add_column :justices, :answer, :text
    add_column :justices, :your_answer, :text
  end
end
