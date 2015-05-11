class AddAttachmentPictureToLessons < ActiveRecord::Migration
  def self.up
    change_table :lessons do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :lessons, :picture
  end
end
