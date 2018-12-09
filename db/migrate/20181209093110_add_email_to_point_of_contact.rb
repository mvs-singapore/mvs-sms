class AddEmailToPointOfContact < ActiveRecord::Migration[5.2]
  def change
    add_column :point_of_contacts, :email, :string
  end
end
