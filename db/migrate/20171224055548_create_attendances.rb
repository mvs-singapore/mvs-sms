class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :date
      t.string :attendance_status
      t.string :reason
      t.string :remark
      t.references :student, foreign_key: true
      t.references :school_class, foreign_key: true

      t.timestamps
    end
  end
end
