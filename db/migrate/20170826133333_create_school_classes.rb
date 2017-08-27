class CreateSchoolClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :school_classes do |t|
      t.integer :academic_year
      t.string :name
      t.integer :year
      t.integer :form_teacher_id, index: true

      t.timestamps
    end
  end
end
