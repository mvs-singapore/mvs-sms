class CreateStudentDisabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :student_disabilities do |t|
      t.references :student, foreign_key: true
      t.references :disability, foreign_key: true

      t.timestamps
    end
  end
end
