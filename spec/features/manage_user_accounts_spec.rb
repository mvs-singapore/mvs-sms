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

  xdescribe 'new user' do
    it 'creates new user with role' do
      sign_in super_user

      visit '/admin/users/'
      click_link 'New User'

      within('#new_user') do
        fill_in 'Email', with: 'teacher@example.com'
        fill_in 'Name', with: 'Yammy'
        select('Teacher', :from => 'User Role')
      end
      click_button 'Create User'

      expect(page).to have_text 'Successfully created user.'

      #TODO Ensure email was sent.
    end
  end
end