class Remark < ApplicationRecord
  validates :event_date, :category, presence: true
  belongs_to :student
  belongs_to :user

  enum category: [:incident, :new_admission, :promoted, :retained, :internship_notes, :graduated, :dropped_out, :awarded, :withdrew]
end
