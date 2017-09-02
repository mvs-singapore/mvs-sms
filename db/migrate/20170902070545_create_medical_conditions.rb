class CreateMedicalConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :medical_conditions do |t|
      t.string :title

      t.timestamps
    end
  end
end
