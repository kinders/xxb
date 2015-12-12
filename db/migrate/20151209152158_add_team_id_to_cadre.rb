class AddTeamIdToCadre < ActiveRecord::Migration
  def change
    add_reference :cadres, :team, index: true
    add_foreign_key :cadres, :teams
  end
end
