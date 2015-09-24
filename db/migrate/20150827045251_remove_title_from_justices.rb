class RemoveTitleFromJustices < ActiveRecord::Migration
  def change
    remove_column :justices, :title, :string
    remove_column :justices, :question, :text
    remove_column :justices, :answer, :text
    remove_column :justices, :yuor_answer, :text
    remove_column :justices, :practice_score, :decimal
    remove_column :justices, :material, :text
  end
end
