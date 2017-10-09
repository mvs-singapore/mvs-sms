class CreateFinancialAssistanceRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_assistance_records do |t|
      t.string :type
      t.string :year_obtained
      t.string :duration
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
