class Attachment < ApplicationRecord

  enum document_type: {
    nric: 'NRIC',
    certificate: 'Certificate',
    others: 'Others'
  }

  validates_presence_of :document_type
  belongs_to :student
  mount_uploader :filename, AttachmentUploader
end
