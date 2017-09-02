class AddMedicationAndAllergiesToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :medication_needed, :text
    add_column :students, :allergies, :text
  end
end
