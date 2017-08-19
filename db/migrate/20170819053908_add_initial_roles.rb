class AddInitialRoles < ActiveRecord::Migration[5.1]
  def change
    [{ name: 'super_admin', super_admin: true }, { name: 'teacher' }].each do |attr|
      Role.create(attr)
    end
  end
end
