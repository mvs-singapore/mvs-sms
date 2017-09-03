class InternshipSupervisor < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :contact_number
  belongs_to :internship_company
  has_many :internship_records
end
