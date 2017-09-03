class Remark < ApplicationRecord
  validates :event_date, :category, presence: true
  belongs_to :student
  belongs_to :user
end
