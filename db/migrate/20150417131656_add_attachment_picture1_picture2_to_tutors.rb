class AddAttachmentPicture1Picture2ToTutors < ActiveRecord::Migration
  def self.up
    change_table :tutors do |t|
      t.attachment :picture1
      t.attachment :picture2
    end
  end

  def self.down
    remove_attachment :tutors, :picture1
    remove_attachment :tutors, :picture2
  end
end
