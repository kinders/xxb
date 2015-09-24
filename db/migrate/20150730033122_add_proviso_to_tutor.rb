class AddProvisoToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :proviso, :text
  end
end
