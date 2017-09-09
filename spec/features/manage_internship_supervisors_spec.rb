require 'rails_helper'

describe 'manage internship supervisors', type: :feature do
  let!(:default_internship_company) { InternshipCompany.create(name: 'xyz', address: 'Singapore', postal_code: '123456') }
  let!(:default_supervisor) { InternshipSupervisor.create(name: 'aaaa', email: 'some@gmail.com', contact_number: '1234', internship_company: default_internship_company)}
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password', name: 'Super Admin', role: super_admin_role) }
  let!(:garbage_collector) { InternshipSupervisor.create(name: 'garbage_collector', email: 'garbage@gmail.com', contact_number: '123456', internship_company: default_internship_company) }

  before do
    sign_in super_user
    visit '/internship_supervisors/'
  end

  describe 'create internship supervisor' do
    it 'creates new internship supervisor' do
      click_link 'Add Supervisor'
      within('#new_internship_supervisor') do
        fill_in 'Supervisor Name', with: 'abc'
        fill_in 'Email', with: 'abc@gmail.com'
        fill_in 'Contact Number', with: '12345678'
        select(default_internship_company.name, :from => 'Internship Company')
      end

      click_button 'Create Internship supervisor'

      expect(page).to have_text 'Successfully created internship supervisor'
      expect(InternshipSupervisor.where(name: 'abc').count).to eq 1
    end
  end

  describe 'edit internship supervisor' do
    it 'edits an existing internship supervisor' do
      within("#supervisor-#{default_supervisor.id}") do
        find_link('Edit').click
      end

      within('.edit_internship_supervisor') do
        fill_in 'Supervisor Name', with: 'some supervisor'
      end
      click_button 'Update Internship supervisor'

      expect(page).to have_text 'Successfully updated internship supervisor'

      expect(default_supervisor.reload.name).to eq 'some supervisor'  
    end
  end

  describe 'delete internship supervisor', js: true do
    it 'deletes an existing supervisor' do
      within("#supervisor-#{garbage_collector.id}") do
        accept_confirm_dialog {
          find_link('Delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted internship supervisor'
      expect(InternshipSupervisor.where(name: 'garbage_collector').count).to eq 0
    end
  end
end
