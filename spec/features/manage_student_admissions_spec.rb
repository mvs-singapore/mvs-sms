require 'rails_helper'

describe 'new student admissions', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:student) { Student.create(admission_year: 2016, admission_no: '16006/2016', registered_at: Date.today, current_class: 'Food & Beverage',
                                  status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', referral_notes: 'Mdm Referee',
                                  surname: 'Lee', given_name: 'Ali', date_of_birth: Date.today, place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female', sadeaf_client_reg_no: '12345/234',
                                  highest_standard_passed: 'GCE O Levels', medication_needed: 'Antihistamines', allergies: 'Peanuts')
  }

  before do
    sign_in teacher_user
  end

  describe 'create student' do
    it 'creates new student' do
      visit '/students/'
      click_link 'Add Student'

      within('#new_student') do
        fill_in 'Admission Year', with: '2017'
        fill_in 'Admission No.', with: '16006/2016'
        fill_in 'Date of Registration', with: Date.today
        fill_in 'Current Class', with: 'Food & Beverage'
        select('new_admission', from: 'Status')
        select('association_of_persons_with_special_needs', from: 'Referred By')
        fill_in 'Name of Referee', with: 'Mdm Referee'
        fill_in 'Surname', with: 'Lee'
        fill_in 'Given Name', with: 'Ali'
        fill_in 'Date of Birth', with: Date.today
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Race', with: 'Chinese'
        fill_in 'NRIC', with: 'S8888888D'
        fill_in 'Citizenship', with: 'Singaporean'
        select('female', from: 'Gender')
        fill_in 'SADeaf Client Registration No.', with: '12345/234'
        fill_in 'Highest Standard Passed', with: 'GCE O Levels'
        fill_in 'Medication Needed', with: 'Antihistamines'
        fill_in 'Allergies', with: 'Peanuts'
      end

      click_button 'Create Student'

      expect(page).to have_text 'Successfully created student'
      expect(page).to have_text 'Ali'

      new_student = Student.last
      expect(new_student.admission_year).to eq 2017
      expect(new_student.admission_no).to eq '16006/2016'
      expect(new_student.registered_at).to eq Date.today
      expect(new_student.current_class).to eq 'Food & Beverage'
      expect(new_student.status).to eq 'new_admission'
      expect(new_student.referred_by).to eq 'association_of_persons_with_special_needs'
      expect(new_student.referral_notes).to eq 'Mdm Referee'
      expect(new_student.surname).to eq 'Lee'
      expect(new_student.given_name).to eq 'Ali'
      expect(new_student.date_of_birth).to eq Date.today
      expect(new_student.place_of_birth).to eq 'Singapore'
      expect(new_student.race).to eq 'Chinese'
      expect(new_student.nric).to eq 'S8888888D'
      expect(new_student.citizenship).to eq 'Singaporean'
      expect(new_student.gender).to eq 'female'
      expect(new_student.sadeaf_client_reg_no).to eq '12345/234'
      expect(new_student.highest_standard_passed).to eq 'GCE O Levels'
      expect(new_student.medication_needed).to eq 'Antihistamines'
      expect(new_student.allergies).to eq 'Peanuts'
    end
  end

  describe 'edit student' do

    it 'edits an existing student' do
      visit '/students/'

      within("#student-#{student.id}") do
        find_link('Edit').click
      end
      within('.edit_student') do
        fill_in 'Admission Year', with: 2017
      end
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(student.reload.admission_year).to eq 2017
    end
  end


  describe 'delete student', js: true do

    it 'deletes an existing student' do
      visit '/students/'

      within("#student-#{student.id}") do
        accept_confirm_dialog {
          find('.delete_student', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted student'
      expect(Student.where(given_name: 'Ali', surname: 'Lee').count).to eq 0
    end
  end


end
