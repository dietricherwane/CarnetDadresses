class AddAttachmentAvatarToAdressBooks < ActiveRecord::Migration
  def self.up
    change_table :adress_books do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :adress_books, :avatar
  end
end
