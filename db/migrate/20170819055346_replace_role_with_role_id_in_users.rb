class ReplaceRoleWithRoleIdInUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :role, :string
    add_reference :users, :role, foreign_key: true
  end
end
