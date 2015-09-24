class AddMaterialToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :material, :text
  end
end
