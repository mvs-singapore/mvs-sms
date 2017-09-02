class CreateInternshipRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :internship_records do |t|
      t.references :student, foreign_key: true
      t.references :internship_company, foreign_key: true
      t.references :internship_supervisor, foreign_key: true
      t.date :from_date, null: false
      t.date :to_date
      t.text :comments

      t.timestamps
    end
  end
end
