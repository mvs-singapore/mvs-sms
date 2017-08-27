class SchoolClass < ApplicationRecord
  belongs_to :form_teacher, class_name: "User", foreign_key: "form_teacher_id"
end
