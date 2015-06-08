class AddSubjectIdToHomework < ActiveRecord::Migration
  def change
    add_reference :homeworks, :subject, index: true
    add_foreign_key :homeworks, :subjects
  end
end
