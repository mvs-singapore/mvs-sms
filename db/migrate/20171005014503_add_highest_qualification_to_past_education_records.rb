class AddHighestQualificationToPastEducationRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :past_education_records, :highest_qualification, :boolean
  end
end
