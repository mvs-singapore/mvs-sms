require 'rails_helper'

describe 'manage user accounts', type: :feature do
  let!(:user) { User.create(email: 'user@example.com', password: 'password', role: 'super_admin') }

  it 'signs me in' do
    visit '/users/sign_in'

    within('#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
    end
    click_button 'Log in'

    expect(page).to have_text 'Signed in successfully'
  end
end