require 'rails_helper'

describe 'manage medical conditions', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:teacher_user) { User.create(email: 'yammy@example.com', password: 'password', name: 'Teacher Yammy', role: teacher_role) }
  let!(:default_medical_condition) { MedicalCondition.create(title: 'Epilepsy') }

  let!(:garbage_collector) { MedicalCondition.create(title: 'garbage_collector') }

  before do
    sign_in teacher_user
    visit '/medical_conditions'
  end

  describe 'create medical condition' do
    it 'creates new medical condition' do
      click_link 'Add Medical Condition'
      within('#new_medical_condition') do
        fill_in 'Title', with: 'Asthma'
      end

      click_button 'Create Medical condition'

      expect(page).to have_text 'Successfully created medical condition'
      expect(MedicalCondition.where(title: 'Asthma').count).to eq 1
    end
  end

  describe 'edit medical condition' do
    it 'edits an existing medical condition' do
      within("#medical-condition-#{default_medical_condition.id}") do
        find_link('Epilepsy').click
      end

      within('.edit_medical_condition') do
        fill_in 'Title', with: 'Heart disease'
      end
      click_button 'Update Medical condition'

      expect(page).to have_text 'Successfully updated medical condition'

      expect(default_medical_condition.reload.title).to eq 'Heart disease'
    end
  end

  describe 'delete medical condition', js: true do
    it 'deletes an existing medical condition' do
      within("#medical-condition-#{garbage_collector.id}") do
        accept_confirm_dialog {
          find_link('Delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted medical condition'
      expect(MedicalCondition.where(title: 'garbage_collector').count).to eq 0
    end
  end
end
