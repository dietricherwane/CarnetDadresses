class Image < ActiveRecord::Base
  attr_accessible :alt, :hint, :file

  has_attached_file :file
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
