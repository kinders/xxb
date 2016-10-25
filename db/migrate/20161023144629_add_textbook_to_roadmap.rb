class AddTextbookToRoadmap < ActiveRecord::Migration
  def change
    add_reference :roadmaps, :textbook, index: true
    add_foreign_key :roadmaps, :textbooks
  end
end
