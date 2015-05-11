class AddAttachmentPictureYaToEvaluations < ActiveRecord::Migration
  def self.up
    change_table :evaluations do |t|
      t.attachment :picture_ya
    end
  end

  def self.down
    remove_attachment :evaluations, :picture_ya
  end
end
