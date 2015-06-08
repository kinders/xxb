class AddUerIdToSubject < ActiveRecord::Migration
  def change
    add_reference :subjects, :user, index: true
    add_foreign_key :subjects, :users
  end
end
