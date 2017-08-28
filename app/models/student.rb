class Student < ApplicationRecord
enum current_level: {new_admission: 'New Admission', year1: 'Year 1', year2: 'Year 2', internship: 'Internship', graduated: 'Graduated', dropped_out: 'Dropped Out', awarded: 'Awarded ITE Cert' }
end
