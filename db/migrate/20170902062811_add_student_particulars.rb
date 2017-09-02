class AddStudentParticulars < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :surname, :string, null: false
    add_column :students, :given_name, :string, null: false
    add_column :students, :date_of_birth, :date, null: false
    add_column :students, :place_of_birth, :string, null: false, default: 'Singapore'
    add_column :students, :race, :string, null: false
    add_column :students, :nric, :string, null: false
    add_column :students, :citizenship, :string, null: false, default: 'Singaporean'
    add_column :students, :gender, :integer, null: false
    add_column :students, :sadeaf_client_reg_no, :string
  end
end
