class AddScoreToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :score, :decimal, default: 1
  end
end
