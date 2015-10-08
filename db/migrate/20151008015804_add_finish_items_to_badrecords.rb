class AddFinishItemsToBadrecords < ActiveRecord::Migration
  def change
    add_column :badrecords, :finish_man, :integer
    add_column :badrecords, :finish_time, :datetime
  end
end
