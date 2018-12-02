class RemoveNotNullFromStudent < ActiveRecord::Migration[5.2]
  def change
    change_column_null :students, :registered_at, true
    change_column_null :students, :referred_by, true
    change_column_null :students, :race, true
    change_column_null :past_education_records, :from_date, true
    change_column_null :past_education_records, :to_date, true
  end
end
