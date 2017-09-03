class InternshipCompany < ApplicationRecord
  validates_presence_of :name
  has_many :internship_records
end
