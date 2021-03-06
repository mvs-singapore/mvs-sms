class SchoolClass < ApplicationRecord
  belongs_to :form_teacher, class_name: "User", foreign_key: "form_teacher_id"
  has_many :student_classes
  has_many :students, through: :student_classes

  def display_name
    "#{name} (#{academic_year})"
  end
end
