class CreateInternshipCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :internship_companies do |t|
      t.string :name, null: false
      t.text :address
      t.string :postal_code

      t.timestamps
    end
  end
end
