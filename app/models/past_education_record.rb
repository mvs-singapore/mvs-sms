class PastEducationRecord < ApplicationRecord
  validates :school_name, presence: true
  belongs_to :student
end
