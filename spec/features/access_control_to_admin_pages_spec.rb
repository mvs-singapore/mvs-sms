require 'rails_helper'

describe 'access_control_to_admin_pages', type: :feature do
  before do
    teacher = Role.create(name: 'teacher')
    super_admin = Role.create(name: 'super_admin', super_admin: true)
    principal = Role.create(name: 'principal', super_admin: true)
    vice_principal = Role.create(name: 'vice_principal')
    clerk = Role.create(name: 'clerk')
    case_worker = Role.create(name: 'case_worker')
  end

  describe 'forbids non super admin to /admin/users page' do
    User.roles.each do |role|
      next if role.super_admin

      it "user with role #{role.name}" do
        user = User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher 1', role: role)

        sign_in user
        visit '/admin/users/'

        expect(page).to have_text 'Unauthorized access'
      end
    end
  end

  xdescribe 'forbids non super admin to /admin/roles page' do
    User.roles.each do |role|
      next if role.super_admin

      it "user with role #{role.name}" do
        user = User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher 1', role: role)
        sign_in user
        visit '/admin/roles/'

        expect(page).to have_text 'Unauthorized access'
      end
    end
  end

  xdescribe 'forbids non super admin to /admin/student_phases page' do
    User.roles.each do |role|
      next if role.super_admin

      it "user with role #{role.name}" do
        user = User.create(email: 'teacher@example.com', password: 'password',
                           name: 'Teacher 1', role: role)
        sign_in user
        visit '/admin/student_phases/'

        expect(page).to have_text 'Unauthorized access'
      end
    end
  end
end
