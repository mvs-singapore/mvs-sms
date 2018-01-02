require 'rails_helper'

describe 'manage internship companies', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:teacher) { User.create(email: 'teacher@example.com', password: 'password', name: 'Some Teacher', role: teacher_role) }
	let!(:hilton_hotel) { InternshipCompany.create(name: 'Hilton Hotel', address: 'Raffles Place 145', postal_code: '156789') }
  let!(:milton_hotel) { InternshipCompany.create(name: 'Milton Hotel', address: 'Raffles City 175', postal_code: '768789') }
  let!(:supervisor) { InternshipSupervisor.create(name: 'aaaa', email: 'some@gmail.com', contact_number: '1234', internship_company: hilton_hotel)}
  let!(:student) { Student.create(admission_year: 2017, registered_at: Date.new(2017,02,03), referred_by: 'Some Random School',
    surname: 'Smith', given_name: 'John', status: 'new_admission', place_of_birth: 'Singapore', citizenship: 'Singaporean',
    date_of_birth: Date.new(1995,02,03), race: 'Chinese', nric: '6589264', gender: 'female')}
  let!(:internship_record) {InternshipRecord.create(student_id: student.id, internship_company: hilton_hotel, internship_supervisor: supervisor,
    from_date: Date.new(2017,1,1))}

  before do
    sign_in teacher
    visit '/internship_companies/'
  end

 describe 'create internship company' do
    it 'creates new internship company' do
      click_link 'Add Internship Company'
      within('#new_internship_company') do
        fill_in 'Name', with: 'Holiday Inn'
				fill_in 'Address', with: 'Jalan Besar 138'
				fill_in 'Postal Code', with: '339098'
      end


      click_button 'Create Internship company'

      expect(page).to have_text 'Successfully created internship company'
      expect(InternshipCompany.where(name: 'Holiday Inn').count).to eq 1
    end
  end

  describe 'edit internship company' do
    it 'edits an existing internship company' do
      within("#internship-company-#{hilton_hotel.id}") do
        find_link('Edit').click
      end

      within('.edit_internship_company') do
        fill_in 'Address', with: 'Kallang Rd 356'
      end
      click_button 'Update Internship company'

      expect(page).to have_text 'Successfully updated internship company'

      expect(hilton_hotel.reload.address).to eq 'Kallang Rd 356'
    end
  end

	describe 'show internship company' do
    it 'shows new internship company' do
      within("#internship-company-#{hilton_hotel.id}") do
        find_link('Hilton Hotel').click
      end

      expect(page).to have_text 'Supervisor List'
      expect(page).to have_text 'Students Assigned List'

      within("#supervisor-#{supervisor.id}") do
        expect(page).to have_text 'aaaa'
        expect(page).to have_text 'some@gmail.com'
        expect(page).to have_text '1234'
      end

      within("#student-#{student.id}") do
        expect(page).to have_text 'Smith, John'
        expect(page).to have_text 'aaaa'
      end

    end
  end

  describe 'delete internship company', js: true do
    it 'deletes an existing internship company' do
      within("#internship-company-#{milton_hotel.id}") do
        accept_confirm_dialog {
          find_link('Delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted internship company'
      expect(InternshipCompany.where(name: 'Milton Hotel').count).to eq 0
    end
  end
end
