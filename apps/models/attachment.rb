class Attachment < ActiveRecord::Base
  belongs_to :event
  has_attached_file :attachment
  validates_attachment_size :attachment, :less_than => 5.megabytes
end
