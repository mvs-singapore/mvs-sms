class InternshipCompany < ApplicationRecord
  validates_presence_of :name
  has_many :internship_records
  has_many :students, through: :internship_records
  has_many :internship_supervisors
end
