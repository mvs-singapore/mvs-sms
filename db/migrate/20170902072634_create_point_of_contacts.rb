class CreatePointOfContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :point_of_contacts do |t|
      t.string :surname
      t.string :given_name
      t.text :address
      t.string :postal_code
      t.string :race
      t.string :dialect
      t.string :languages_spoken
      t.string :id_number
      t.integer :id_type
      t.date :date_of_birth
      t.string :place_of_birth
      t.string :nationality
      t.string :occupation
      t.string :home_number
      t.string :handphone_number
      t.string :office_number
      t.string :relationship
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end
