class Attachment < ApplicationRecord
  belongs_to :student
  mount_uploader :filename, AttachmentUploader
end
