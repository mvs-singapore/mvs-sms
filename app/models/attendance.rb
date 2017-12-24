class Attendance < ApplicationRecord
  belongs_to :student
  belongs_to :school_class

  enum attendance_status: [:present, :absent, :late]
  enum reason:  {
    mc: 'MC',
    ns_checkup: 'NS Checkup',
    excuse_letter: 'Excuse Letter',
    others: 'Others'
  }

end
