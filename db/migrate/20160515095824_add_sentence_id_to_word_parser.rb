class AddSentenceIdToWordParser < ActiveRecord::Migration
  def change
    add_reference :word_parsers, :sentence, index: true
    add_foreign_key :word_parsers, :sentences
  end
end
