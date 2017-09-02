class InternshipSupervisor < ApplicationRecord
  belongs_to :internship_company
  has_many :internship_records
end
