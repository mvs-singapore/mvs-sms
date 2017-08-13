require 'rails_helper'

xdescribe 'manage user roles', type: :feature do
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password', name: 'Super Admin', role: super_admin_role) }

  before do
    sign_in super_user
    visit '/admin/roles/'
  end

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

  describe 'create role' do
    it 'creates new role' do
      click_link 'Add Role'

      within('#new_role') do
        fill_in 'Name', with: 'psychiatrist'
      end

      click_button 'Create User'

      expect(page).to have_text 'Successfully created role'
      expect(Role.where(name: 'psychiatrist').count).to eq 1
    end
  end

  describe 'edit role' do
    let!(:social_worker_role) { Role.create(name: 'socialworker', super_admin: false) }

    it 'edits an existing role' do
      find_link(social_worker_role.name, visible: true).click

      within('.edit_role') do
        fill_in 'Name', with: 'social_worker'
      end
      click_button 'Update Role'

      expect(page).to have_text 'Successfully updated role'

      expect(social_worker_role.reload.name).to eq 'social_worker'
    end
  end

  describe 'delete role' do
    let!(:garbage_collector) { Role.create(name: 'garbage_collector', super_admin: false) }

    it 'deletes an existing role' do
      within("role-#{garbage_collector.id}") do
        accept_confirm_dialog {
          find_link('delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted role'
      expect(Role.where(name: 'garbage_collector').count).to eq 0
    end
  end
end