class AddPapertestIdToEvaluation < ActiveRecord::Migration
  def change
    add_reference :evaluations, :papertest, index: true
    add_foreign_key :evaluations, :papertests
  end
end
