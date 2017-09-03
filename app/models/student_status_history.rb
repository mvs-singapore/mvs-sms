class StudentStatusHistory < ApplicationRecord
  validates_presence_of :status
  belongs_to :student
end
