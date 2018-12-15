class AddContactNumberToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :home_number, :string
    add_column :students, :mobile_number, :string
    add_column :students, :address, :string
    add_column :students, :postal_code, :string
  end
end
