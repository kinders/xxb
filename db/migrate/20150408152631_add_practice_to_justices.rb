class AddPracticeToJustices < ActiveRecord::Migration
  def change
    add_reference :justices, :practice, index: true
    add_foreign_key :justices, :practices
  end
end
