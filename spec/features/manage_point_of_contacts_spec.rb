require 'rails_helper'

describe 'manage point of contacts', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:student) { Student.create(admission_year: 2016, admission_no: '16006/2016', registered_at: Date.parse('09/09/2017'),
                                  status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', surname: 'Lee',
                                  given_name: 'Ali', date_of_birth: Date.parse('09/09/1997'), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female')
  }
  let!(:point_of_contact) { PointOfContact.create(surname: 'Tan', given_name: 'Mary', handphone_number: '12345678', relationship: 'Mother', student: student)}


  before do
    sign_in teacher_user
  end

  describe 'edit student point of contacts', js: true do
    it 'edits point of contact' do
      visit students_path
      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('Edit').click
      end

      click_link 'Parent/Guardian Particulars'
      within('#contacts .nested-fields:nth-of-type(1)') do
        fill_in 'Given Name', with: 'Joan'
        fill_in 'Email', with: 'joan@gmail.com'
      end

      page.execute_script "window.scrollBy(0,1000)"
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(point_of_contact.reload.given_name).to eq 'Joan'
      expect(point_of_contact.reload.email).to eq 'joan@gmail.com'
    end
  end

  describe 'delete point of contact record', js: true do
    before do
      mama = { surname: 'Doe', given_name: 'Jean', handphone_number: '12345678', relationship: 'Mother' }
      student.point_of_contacts.create(mama)
    end
    it 'delete contact record' do
      visit students_path
      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('Edit').click
      end

      click_link 'Parent/Guardian Particulars'
      within('#contacts .nested-fields:nth-of-type(1)') do
        accept_confirm_dialog {
          page.execute_script "window.scrollBy(0,1000)"
          find('.delete_contact_record', visible: true).click
        }
      end

      click_button 'Update Student'
      student.reload
      expect(student.point_of_contacts.count).to equal 1
    end
  end
end
