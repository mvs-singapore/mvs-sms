class StudentMedicalCondition < ApplicationRecord
  belongs_to :student
  belongs_to :medical_condition
end
