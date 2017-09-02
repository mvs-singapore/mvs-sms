class InternshipRecord < ApplicationRecord
  belongs_to :student
  belongs_to :internship_company
  belongs_to :internship_supervisor
end
