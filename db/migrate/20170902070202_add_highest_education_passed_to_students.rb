class AddHighestEducationPassedToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :highest_standard_passed, :string
  end
end
