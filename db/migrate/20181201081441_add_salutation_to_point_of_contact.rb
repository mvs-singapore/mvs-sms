class AddSalutationToPointOfContact < ActiveRecord::Migration[5.2]
  def change
    add_column :point_of_contacts, :salutation, :string, null: true
  end
end
