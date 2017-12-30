class ChangeAttendanceColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :attendances, :date, :attendance_date
    rename_column :attendances, :remark, :attendance_remark
  end
end
