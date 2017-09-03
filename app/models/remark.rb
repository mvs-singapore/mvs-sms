class Remark < ApplicationRecord
  validates_presence_of :event_date
  validates_presence_of :category
  belongs_to :student
  belongs_to :user
end
