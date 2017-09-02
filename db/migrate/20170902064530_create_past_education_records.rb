class CreatePastEducationRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :past_education_records do |t|
      t.string :school_name, null: false
      t.date :from_date, null: false
      t.date :to_date, null: false
      t.string :qualification
      t.integer :student_id, index: true

      t.timestamps
    end
  end
end
