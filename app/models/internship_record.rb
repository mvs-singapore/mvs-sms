class InternshipRecord < ApplicationRecord
  validates_presence_of :from_date
  belongs_to :student
  belongs_to :internship_company
  belongs_to :internship_supervisor
end
