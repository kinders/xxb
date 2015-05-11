class RenamePlanSerailColumn < ActiveRecord::Migration
  def change
    rename_column :plans, :serail, :serial
  end
end
