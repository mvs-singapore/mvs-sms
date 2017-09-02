require 'rails_helper'

describe 'update user profiles', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher) { User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher', role: teacher_role) }

  describe 'edit profile', js: true do
    it 'edits current user profile' do
      sign_in teacher
      visit '/'

      click_link 'Teacher'

      within('#edit_user') do
        fill_in 'Email', with: 'yammy@example.com'
        fill_in 'Name', with: 'Yammy'
        fill_in 'Current password', with: 'password'
      end

      click_button 'Update'

      expect(page).to have_text 'Your account has been updated successfully.'

      expect(teacher.reload.name).to eq 'Yammy'
      expect(teacher.reload.email).to eq 'yammy@example.com'
    end
  end
end
