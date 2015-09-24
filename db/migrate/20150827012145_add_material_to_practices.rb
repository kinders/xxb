class AddMaterialToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :material, :text
    add_column :practices, :labelname, :string
    add_column :practices, :mean, :decimal, default: 0
    add_column :practices, :mode, :decimal, default: 0
    add_column :practices, :stdve, :decimal, default: 0
    add_column :practices, :difficulty, :decimal, default: 0
  end
end
