class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.integer :admission_year, limit: 4
      t.string :admission_no
      t.date :regis_date
      t.integer :class
      t.string :current_level

      t.timestamps
    end
  end
end
