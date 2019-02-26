class AddRhymeToPhonetics < ActiveRecord::Migration[5.0]
  def change
    add_column :phonetics, :rhyme, :string
  end
end
