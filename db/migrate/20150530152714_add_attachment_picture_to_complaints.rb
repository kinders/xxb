class AddAttachmentPictureToComplaints < ActiveRecord::Migration
  def self.up
    change_table :complaints do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :complaints, :picture
  end
end
