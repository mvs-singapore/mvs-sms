class Remark < ApplicationRecord
  validates :event_date, :category, presence: true
  belongs_to :student
  belongs_to :user

  enum category: {
    incident: 'Incident',
    new_admission: 'New Admission',
    promoted: 'Promoted',
    retained: 'Retained',
    internship_notes: 'Internship Notes',
    graduated: 'Graduated',
    dropped_out: 'Dropped Out',
    awarded: 'Awarded',
    withdrew: 'Withdrew',
    financial_assistance: 'Financial Assistance',
  }
end
