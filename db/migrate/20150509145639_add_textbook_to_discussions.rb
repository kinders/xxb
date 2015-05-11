class AddTextbookToDiscussions < ActiveRecord::Migration
  def change
    add_reference :discussions, :textbook, index: true
    add_foreign_key :discussions, :textbooks
  end
end
