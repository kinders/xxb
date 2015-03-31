class AddUserToLesson < ActiveRecord::Migration
  def change
    add_reference :lessons, :user, index: true
    add_foreign_key :lessons, :users
  end
end
