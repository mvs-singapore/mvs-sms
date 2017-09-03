class PastEducationRecord < ApplicationRecord
  validates :school_name, :from_date, :to_date, presence: true
  belongs_to :student
end
