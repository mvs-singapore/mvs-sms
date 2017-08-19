class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.boolean :super_admin, default: false

      t.timestamps
    end
  end
end
