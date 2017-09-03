class PastEducationRecord < ApplicationRecord
  validates_presence_of :school_name
  validates_presence_of :from_date
  validates_presence_of :to_date
  belongs_to :student
end
