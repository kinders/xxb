class AddAttachmentPictureQPictureAToPractices < ActiveRecord::Migration
  def self.up
    change_table :practices do |t|
      t.attachment :picture_q
      t.attachment :picture_a
    end
  end

  def self.down
    remove_attachment :practices, :picture_q
    remove_attachment :practices, :picture_a
  end
end
