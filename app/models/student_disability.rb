class StudentDisability < ApplicationRecord
  belongs_to :student
  belongs_to :disability
end
