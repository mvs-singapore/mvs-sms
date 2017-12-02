class Student < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_full_name, :against => [:given_name, :surname]
  has_paper_trail on: [:update], only: [:status]
  after_initialize :default_status

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

  enum tshirt_size: [:XS, :S, :M, :L, :XL, :XXL, :other_size]

  validates :admission_year, :registered_at, :status, :referred_by, :surname, :given_name, :date_of_birth, :place_of_birth, :race, :nric, :citizenship, :gender, presence: true
  validates :admission_year, numericality: { only_integer: true }

  has_many :point_of_contacts, inverse_of: :student, dependent: :destroy
  accepts_nested_attributes_for :point_of_contacts, reject_if: :all_blank, allow_destroy: true
  has_many :internship_records, dependent: :destroy
  accepts_nested_attributes_for :internship_records, reject_if: :all_blank, allow_destroy: true
  has_many :past_education_records, inverse_of: :student, dependent: :destroy
  has_many :point_of_contacts, dependent: :destroy
  has_many :remarks, dependent: :destroy
  accepts_nested_attributes_for :remarks, reject_if: :all_blank, allow_destroy: true
  has_many :student_classes, dependent: :destroy
  has_many :school_classes, through: :student_classes
  has_many :student_disabilities, dependent: :destroy
  has_many :disabilities, through: :student_disabilities
  has_many :student_medical_conditions, dependent: :destroy
  has_many :medical_conditions, through: :student_medical_conditions
  has_many :student_status_histories, dependent: :destroy
  accepts_nested_attributes_for :past_education_records, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :student_disabilities, allow_destroy: true
  accepts_nested_attributes_for :student_medical_conditions, allow_destroy: true
  has_many :financial_assistance_records, inverse_of: :student, dependent: :destroy
  accepts_nested_attributes_for :financial_assistance_records, reject_if: :all_blank, allow_destroy: true
  has_many :attachments, inverse_of: :student, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true


  scope :sorted, -> { order(surname: :asc) }

  def default_status
    self.status ||= 'new_admission'
  end

  def full_name
    "#{surname}, #{given_name}"
  end

  def age
    Date.today.year - date_of_birth.year
  end

  def self.search(search)
    self.search_by_full_name(search)
  end

  def current_class
    school_classes.order('academic_year DESC').try(:first)
  end

  def class_for_year(academic_year)
    school_classes.where(academic_year: academic_year).try(:first)
  end

  def self.filter_by_cohort_and_classes(year, class_name)
    filter = { 'school_classes.academic_year' => year }

    if class_name.present?
      filter['school_classes.name'] = class_name
    end

    Student.joins(student_classes: :school_class).where(filter)
  end

  def self.as_csv(records, options = {})
    attributes = %w{given_name surname admission_year admission_no registered_at current_class status date_of_birth
                    place_of_birth race nric citizenship gender sadeaf_client_reg_no disabilities medical_conditions
                    medication allergies referred_by }
    CSV.generate(options) do |csv|
      csv << attributes
      records.each do |item|
        csv << [item.given_name, item.surname, item.admission_year, item.admission_no, item.registered_at,
                item.current_class.try(:display_name), item.status, item.date_of_birth, item.place_of_birth, item.race, item.nric,
                item.citizenship, item.gender, item.sadeaf_client_reg_no, item.disabilities.pluck(:title).join(','),
                item.medical_conditions.pluck(:title).join(','), item.medication_needed, item.allergies, item.referred_by]
      end
    end
  end
end
