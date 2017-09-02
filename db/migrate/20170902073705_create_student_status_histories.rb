class CreateStudentStatusHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :student_status_histories do |t|
      t.references :student, foreign_key: true
      t.string :status, null: false
      t.text :comment

      t.timestamps
    end
  end
end
