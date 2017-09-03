class InternshipSupervisor < ApplicationRecord
  validates :name, :contact_number, presence: true
  belongs_to :internship_company
  has_many :internship_records
end
