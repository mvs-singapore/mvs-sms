require 'rails_helper'

describe 'manage user roles', type: :feature do
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password', name: 'Super Admin', role: super_admin_role) }
  let!(:social_worker_role) { Role.create(name: 'socialworker') }
  let!(:garbage_collector) { Role.create(name: 'garbage_collector') }

  before do
    sign_in super_user
    visit '/admin/roles/'
  end

  describe 'create role' do
    it 'creates new role' do
      click_link 'Add Role'
      within('#new_role') do
        fill_in 'Name', with: 'psychiatrist'
      end

      click_button 'Create Role'

      expect(page).to have_text 'Successfully created role'
      expect(Role.where(name: 'psychiatrist').count).to eq 1
    end
  end

  describe 'edit role' do
    it 'edits an existing role' do
      within("#role-#{social_worker_role.id}") do
        find_link('Edit').click
      end

      within('.edit_role') do
        fill_in 'Name', with: 'social_worker'
      end
      click_button 'Update Role'

      expect(page).to have_text 'Successfully updated role'

      expect(social_worker_role.reload.name).to eq 'social_worker'
    end
  end

  describe 'delete role', js: true do
    it 'deletes an existing role' do
      within("#role-#{garbage_collector.id}") do
        accept_confirm_dialog {
          find_link('Delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted role'
      expect(Role.where(name: 'garbage_collector').count).to eq 0
    end
  end
end