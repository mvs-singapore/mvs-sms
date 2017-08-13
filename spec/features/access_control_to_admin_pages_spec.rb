require 'rails_helper'

xdescribe 'access_control_to_admin_pages', type: :feature do
  describe 'forbids non super admin to /admin/roles page' do
    User.roles.keys.each do |role|
      next if role == 'super_admin'

      it "user with role #{role}" do
        user = User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher 1', role: role)
        sign_in user
        visit '/admin/roles/'

        expect(page).to have_text 'Unauthorized access'
      end
    end
  end

  describe 'forbids non super admin to /admin/student_phases page' do
    User.roles.keys.each do |role|
      next if role == 'super_admin'

      it "user with role #{role}" do
        user = User.create(email: 'teacher@example.com', password: 'password',
                           name: 'Teacher 1', role: role)
        sign_in user
        visit '/admin/student_phases/'

        expect(page).to have_text 'Unauthorized access'
      end
    end
  end
end
