class AddIsReadyToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :is_ready, :boolean, default: false
  end
end
