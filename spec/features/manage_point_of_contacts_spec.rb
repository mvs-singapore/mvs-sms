require 'rails_helper'

xdescribe 'point of contacts', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:student) { Student.create(admission_year: 2016, admission_no: '16006/2016', registered_at: Date.parse('09/09/2017'), current_class: 'Food & Beverage',
                                  status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', referral_notes: 'Mdm Referee',
                                  surname: 'Lee', given_name: 'Ali', date_of_birth: Date.parse('09/09/1997'), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female', sadeaf_client_reg_no: '12345/234',
                                  highest_standard_passed: 'GCE O Levels', medication_needed: 'Antihistamines', allergies: 'Peanuts')
  }
  let!(:point_of_contact) { PointOfContact.create(surname: 'Ong', given_name: 'Pearly', address: '5 Smith Street', postal_code: '987654', race: 'Chinese',
                                                  dialect: 'Teochew', languages_spoken: 'English', id_number: 'S8888888D', id_type: 'blue',
                                                  date_of_birth: Date.new(2000,1,1), place_of_birth: 'Singapore', nationality: 'Singaporean',
                                                  occupation: 'Clerk', home_number: '65556555', handphone_number: '87778777', office_number: '61116111',
                                                  relationship: 'Mother', student: student) }

  before do
    sign_in teacher_user
  end

  describe 'add point of contact within add point of contact page' do
    it 'adds a point of contact' do
      visit students_path

      within("#student-#{student.id}") do
        find_link('View').click
      end

      find('.add_student_point_of_contact').click

      within('.new_point_of_contact') do
        fill_in 'Surname', with: 'Ong'
        fill_in 'Given Name', with: 'Pearly'
        fill_in 'Address', with: '5 Smith Street'
        fill_in 'Postal Code', with: '987654'
        fill_in 'Race', with: 'Chinese'
        fill_in 'Dialect', with: 'Teochew'
        fill_in 'Languages Spoken', with: 'English'
        fill_in 'ID Number', with: 'S8888888D'
        select('blue', from: 'ID Type')
        fill_in 'Date of Birth', with: '01/01/2000'
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Nationality', with: 'Singaporean'
        fill_in 'Occupation', with: 'Clerk'
        fill_in 'Home Number', with: '65556555'
        fill_in 'Handphone Number', with: '87778777'
        fill_in 'Office Number', with: '61116111'
        fill_in 'Relationship', with: 'Mother'
      end
      click_button 'Create Point of contact'

      expect(page).to have_text 'Successfully created point of contact'
      expect(PointOfContact.where(relationship: 'Mother').count).to eq 1
    end
  end

  describe 'edit point of contact within edit student page' do
    it 'edits an existing point of contact' do
      visit students_path

      within("#student-#{student.id}") do
        find_link('Edit').click
      end
      within('.edit_student') do
        fill_in 'Dialect', with: 'Cantonese'
      end
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(point_of_contact.reload.dialect).to eq 'Cantonese'
    end
  end

  describe 'edit point of contact within edit point of contact page', js: true do
    it 'edits an existing point of contact' do
      visit students_path

      within("#student-#{student.id}") do
        find_link('View').click
      end

      within("#contact-#{point_of_contact.id}") do
        find_link('Edit').click
      end

      within('.edit_point_of_contact') do
        fill_in 'Address', with: 'Jalan Bingka'
      end

      click_button 'Update Point of contact'

      expect(page).to have_text 'Successfully updated point of contact'
      expect(point_of_contact.reload.address).to eq 'Jalan Bingka'
    end
  end

  describe 'delete point of contact', js: true do
    it 'deletes an existing point of contact' do
      visit students_path

      within("#student-#{student.id}") do
        find_link('View').click
      end

      within("#contact-#{point_of_contact.id}") do
        accept_confirm_dialog {
          find('.delete_student_point_of_contact', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted point of contact'
      expect(PointOfContact.where(given_name: 'Pearly').count).to eq 0
    end
  end

end
