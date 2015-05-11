class AddEndAtToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :end_at, :datetime
  end
end
