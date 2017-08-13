require 'rails_helper'

xdescribe 'manage student phases', type: :feature do
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password',
                                  name: 'Super Admin', role: super_admin_role) }
  let!(:new_admission) { StudentPhase.create(name: 'new_admission', sort_order: 1) }

  before do
    sign_in super_user
    visit '/admin/student_phases'
  end

  describe 'create student_phase' do
    it 'creates new phases' do
      click_link 'Add Phase'

      within('#new_student_phase') do
        fill_in 'Name', with: 'new_admission'
        fill_in 'Order', with: '1'
      end

      click_button 'Create Student Phase'

      expect(page).to have_text 'Successfully created student phase'
      expect(StudentPhase.where(name: 'new_admission').count).to eq 1
    end
  end

  describe 'edit student_phase' do
    let!(:year_one) { StudentPhase.create(name: 'year_1', sort_order: 2) }

    it 'edits an existing role' do
      find_link(year_one.name, visible: true).click

      within('.edit_student_phase') do
        fill_in 'Name', with: 'year_one'
      end
      click_button 'Update Student Phase'

      expect(page).to have_text 'Successfully updated student phase'

      expect(year_one.reload.name).to eq 'year_one'
    end
  end

  describe 'delete student phase' do
    let!(:year_three) { StudentPhase.create(name: 'year_three', sort_order: 3) }

    it 'deletes an existing student phase' do
      within("#student-phase-#{year_three.id}") do
        accept_confirm_dialog {
          find_link('delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted student phase'
      expect(StudentPhase.where(name: 'year_three').count).to eq 0
    end
  end
end