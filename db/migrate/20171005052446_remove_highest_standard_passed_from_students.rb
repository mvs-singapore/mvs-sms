class RemoveHighestStandardPassedFromStudents < ActiveRecord::Migration[5.1]
  def change
    remove_column :students, :highest_standard_passed, :string
  end
end
