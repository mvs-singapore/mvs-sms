class AddMandatoryRelationshipToPointofcontacts < ActiveRecord::Migration[5.1]
  def change
  	change_column_null :point_of_contacts, :relationship, :string, null: false
  end
end
