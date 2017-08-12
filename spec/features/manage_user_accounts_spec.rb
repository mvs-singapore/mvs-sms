require 'rails_helper'

describe 'manage user accounts', type: :feature do
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password', name: 'Super Admin', role: 'super_admin') }

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

      #TODO Ensure email was sent.
    end
  end

  describe 'current user' do
    let!(:user){ User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher 1', role: 'teacher') }

    it 'edit user with role' do
      sign_in super_user

      visit '/admin/users/'
      first('a.edit_user').click

      within('.edit_user') do
        fill_in 'Name', with: 'Yammy'
        fill_in 'Email', with: 'yammy@example.com'
      end
      click_button 'Update User'

      expect(page).to have_text 'Successfully updated user'

      user.reload
      expect(user.name).to eq 'Yammy'
      expect(user.email).to eq 'yammy@example.com'

      #TODO Ensure email was sent.
    end
  end

  xdescribe 'current user' do
    before do
      User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher 1', role: 'teacher')
    end

    it 'deletes existing user', js: true do
      sign_in super_user

      visit '/admin/users/'

      accept_confirm_dialog { first('a.delete_user').click }

      expect(page).to have_text 'Successfully deleted user.'

      #TODO Ensure email was sent.
    end
  end

  xdescribe 'current user' do
    it 'forbids non super admin to /admin/users page' do
      User::USER_ROLES.each do |role|
        next if role == 'super_user'

        user = User.create(email: 'teacher@example.com', password: 'password', name: 'Teacher 1', role: role)
        sign_in user
        visit '/admin/users/'

        expect(page).to have_text 'Unauthorized access.'
      end
    end
  end
end