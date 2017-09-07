class Student < ApplicationRecord
  enum status: {
    new_admission: 'New Admission',
    year1: 'Year 1',
    year2: 'Year 2',
    internship: 'Internship',
    graduated: 'Graduated',
    dropped_out: 'Dropped Out',
    awarded: 'Awarded ITE Cert'
  }

  enum institution: {
    association_of_persons_with_special_needs: 'Association of Persons with Special Needs',
    canossian_school_for_the_hearing_impaired: 'Canossian School for the Hearing-Impaired',
    singapore_association_for_the_deaf: 'Singapore Association for the Deaf',
    singapore_school_for_the_deaf: 'Singapore School for the Deaf',
    other: 'Other special education institutions (please specify)',
    self_referred: 'Self-referred'
  }

  enum gender: [:female, :male]

  validates :admission_year, :registered_at, :status, :referred_by, :surname, :given_name, :date_of_birth, :place_of_birth, :race, :nric, :citizenship, :gender, presence: true
  validates :admission_year, numericality: { only_integer: true }
  has_many :internship_records
  has_many :past_education_records
  has_many :point_of_contacts
  has_many :remarks
  has_many :student_classes
  has_many :school_classes, through: :student_classes
  has_many :student_disabilities
  has_many :disabilities, through: :student_disabilities
  has_many :student_medical_conditions
  has_many :medical_conditions, through: :student_medical_conditions
  has_many :student_status_histories
end
