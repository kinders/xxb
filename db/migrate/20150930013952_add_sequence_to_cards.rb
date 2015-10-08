class AddSequenceToCards < ActiveRecord::Migration
  def change
    add_column :cards, :sequence, :integer
  end
end
