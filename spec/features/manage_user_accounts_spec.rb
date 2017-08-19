require 'rails_helper'

describe 'manage user accounts', type: :feature do
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) do
    User.create(email: 'admin@example.com', password: 'password',
                name: 'Super Admin', role: super_admin_role)
  end

  it 'signs me in' do
    visit '/users/sign_in'

    within('#new_user') do
      fill_in 'Email', with: super_user.email
      fill_in 'Password', with: 'password'
    end
    click_button 'Log in'

    expect(page).to have_text 'Signed in successfully'
  end

  describe 'new user' do
    it 'creates new user with role' do
      sign_in super_user

      visit '/admin/users/'
      click_link 'Add User'

      within('#new_user') do
        fill_in 'Name', with: 'Yammy'
        fill_in 'Email', with: 'teacher@example.com'
        select('teacher', :from => 'Role')
      end

      click_button 'Create User'

      expect(page).to have_text 'Successfully created user'

      received_email = open_email('teacher@example.com', with_subject: "New User Account: Yammy (teacher@example.com)")
      expect(received_email.body.encoded).to include "Welcome Yammy, to MVS-Student Management System"
    end
  end

  describe 'current user' do
    let!(:teacher) { Role.create(name: 'teacher') }
    let!(:user) do
      User.create(email: 'teacher@example.com', password: 'password',
                  name: 'Teacher 1', role: teacher)
    end

    it 'edit user with role' do
      sign_in super_user

      visit '/admin/users/'
      find(:xpath, "//tr[td[contains(., 'Teacher 1')]]/td/a", :text => 'Edit').click
      within('.edit_user') do
        fill_in 'Name', with: 'Yammy'
        fill_in 'Email', with: 'yammy@example.com'
      end
      click_button 'Update User'

      expect(page).to have_text 'Successfully updated user'

      user.reload
      expect(user.name).to eq 'Yammy'
      expect(user.email).to eq 'yammy@example.com'
    end

    it 'deletes existing user', js: true do
      sign_in super_user

      visit '/admin/users/'
      accept_confirm_dialog { first('a.delete_user').click }

      expect(page).to have_text 'Successfully deleted user'
      expect(User.where(email: 'teacher@example.com').count).to eq 0
    end


  end
end