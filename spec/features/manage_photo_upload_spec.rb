require 'rails_helper'

describe 'student photo upload', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:student) { Student.create(admission_year: 2016, registered_at: Date.parse('09/09/2017'),
                                  status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', surname: 'Lee',
                                  given_name: 'Ali', date_of_birth: Date.parse('09/09/1997'), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female')
  }

  before do
    sign_in teacher_user
  end

  fdescribe 'create student', js: true do
    it 'creates new student with photo upload' do
      visit students_path
      click_link 'Students'
      click_link 'Add New Student'

      page.execute_script "window.scrollTo(0,0)"
      within('#student-particulars') do
        attach_file('file', Rails.root + 'spec/support/images/student-upload-photo-test.png', visible: false)
        # find('form input[type="file"]').set(Rails.root + 'spec/support/images/student-upload-photo-test.jpg')
        fill_in 'Surname', with: 'Lee'
        fill_in 'Given Name', with: 'Ali'
        fill_in 'Date of Birth', with: '09/09/1997'
        find('#student_race').click
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Race', with: 'Chinese'
        fill_in 'NRIC', with: 'S8888888D'
        fill_in 'Citizenship', with: 'Singaporean'
        select('female', from: 'Gender')
        sleep(10)

      end

      page.execute_script "window.scrollBy(0,200)"

      fill_in 'Admission Year', with: '2017'
      fill_in 'Date of Registration', with: '09/09/2017'
      select('new_admission', from: 'Status')
      select('association_of_persons_with_special_needs', from: 'Referred By')

      page.execute_script "window.scrollTo(0,0)"

      click_link 'Past Education Records'
      within('#past-educations .nested-fields:nth-of-type(1)') do
        find('td[data-for="school_name"] input').set('Northlight')
        find('td[data-for="from_date"] input').set('02/03/2016')
        find('td[data-for="to_date"] input').set('02/03/2017')
      end

      page.execute_script "window.scrollBy(0,10000)"
      click_button 'Create Student'

      expect(page).to have_text 'Successfully created student'
      new_student = Student.last
      expect(new_student.image_id).to eq 'Autistic'
    end
  end

end
