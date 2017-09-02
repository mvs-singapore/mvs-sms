class CreateStudentMedicalConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :student_medical_conditions do |t|
      t.references :student, foreign_key: true
      t.references :medical_condition, foreign_key: true

      t.timestamps
    end
  end
end
