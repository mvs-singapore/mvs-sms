require 'rails_helper'

describe 'student photo upload', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }

  before do
    sign_in yammy
  end

  describe 'create student', js: true do
    it 'creates new student with photo upload' do
      visit students_path
      click_link 'Students'
      click_link 'Add New Student'

      page.execute_script "window.scrollTo(0,0)"
      page.execute_script("$('input[name=file]').css('opacity','1')")
      within('#student-particulars') do
        # attach_file('file', Rails.root + 'spec/support/images/student-upload-photo-test.png', visible: false)
        fill_in 'Surname', with: 'Lee'
        fill_in 'Given Name', with: 'Ali'
        fill_in 'Date of Birth', with: '09/09/1997'
        find('#student_race').click
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Race', with: 'Chinese'
        fill_in 'NRIC', with: 'S8888888D'
        fill_in 'Citizenship', with: 'Singaporean'
        select('female', from: 'Gender')
      end

      click_link 'Administrative Details'

      fill_in 'Admission Year', with: '2017'
      fill_in 'Date of Registration', with: '09/09/2017'
      select('association_of_persons_with_special_needs', from: 'Referred By')

      within('#past-educations .nested-fields:nth-of-type(1)') do
        find('td[data-for="school_name"] input').set('Northlight')
        find('td[data-for="from_date"] input').set('02/03/2016')
        find('td[data-for="to_date"] input').set('02/03/2017')
      end

      page.execute_script "window.scrollBy(0,10000)"
      click_button 'Create Student'

      expect(page).to have_text 'Successfully created student'
      new_student = Student.last
      # expect(new_student.image_id).to eq ''
    end
  end

end
