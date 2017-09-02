class CreateInternshipSupervisors < ActiveRecord::Migration[5.1]
  def change
    create_table :internship_supervisors do |t|
      t.string :name, null: false
      t.string :email
      t.string :contact_number, null: false
      t.references :internship_company, foreign_key: true

      t.timestamps
    end
  end
end
