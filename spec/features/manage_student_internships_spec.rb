require 'rails_helper'

describe 'add internship records to student profile', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:default_student) { Student.create(admission_year: 2016, registered_at: Date.new(2017,9,9), status: 'new_admission',
                                  referred_by: 'association_of_persons_with_special_needs', surname: 'Lim', given_name: 'Kate',
                                  date_of_birth: Date.new(1997,9,9), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female') }
  let!(:hilton_hotel) { InternshipCompany.create(name: 'Hilton Hotel', address: 'Raffles Place 145', postal_code: '156789') }
  let!(:milton_hotel) { InternshipCompany.create(name: 'Milton Hotel', address: 'Raffles City 175', postal_code: '768789') }
  let!(:supervisor) { InternshipSupervisor.create(name: 'aaaa', email: 'some@gmail.com', contact_number: '1234', internship_company: hilton_hotel)}
  let!(:internship_record) {InternshipRecord.create(student_id: default_student.id, internship_company: hilton_hotel, internship_supervisor: supervisor,
    from_date: Date.new(2017,1,1), to_date: Date.new(2017,3,1), comments: 'Good boy')}

  before do
    sign_in teacher_user
  end

  describe 'add internship records to student profile within edit student page', js: true do
    it 'adds an internship record to student profile' do
      visit students_path

      within("#student-#{default_student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{default_student.id}") do
        find_link('Edit').click
      end

      page.execute_script "window.scrollTo(0,0)"

      click_link 'Internship Records'

      within("#internship-records .nested-fields:nth-of-type(1)") do
        select('Milton Hotel', from: 'student_internship_records_attributes_0_internship_company_id')
        select('aaaa', from: 'student_internship_records_attributes_0_internship_supervisor_id')
        fill_in 'student_internship_records_attributes_0_from_date', with: '01/02/2017'
        fill_in 'student_internship_records_attributes_0_to_date', with: '03/02/2017'
        fill_in 'student_internship_records_attributes_0_comments', with: 'Good boy'
      end

      page.execute_script "window.scrollBy(0,10000)"

      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(default_student.internship_records.count).to eq 1
    end
  end
end

  # describe 'edit internship within edit student page' do
  #   it 'edits an existing internship' do
  #     visit students_path

  #     within("#student-#{default_student.id}") do
  #       find_link('View').click
  #     end
  #     within("#internship-#{internship.id}") do
  #       find_link('Edit').click
  #     end

  #     within('.edit_internship') do
  #       fill_in 'Details', with: 'Student slapped another student'
  #     end
  #     click_button 'Update internship'

  #     expect(page).to have_text 'Successfully updated internship'
  #     expect(internship.reload.details).to eq 'Student slapped another student'
  #     end
  #   end

  # describe 'view internships' do
  #   it 'displays the details of a internship' do
  #     visit students_path

  #     within("#student-#{default_student.id}") do
  #       find_link('View').click
  #     end
  #     internships = page.find '#student_internships'
  #     expect(internships).to have_link 'Edit'
  #     expect(internships).to have_link 'Delete'

  #     expect(find('#student_internships dd[data-for="event_date"]')).to have_content '2017'
  #     expect(find('#student_internships dd[data-for="category"]')).to have_content 0
  #     expect(find('#student_internships dd[data-for="details"]')).to have_content 'Student'
  #   end
  # end

  # describe 'delete internship', js: true do
  #   it 'deletes an existing internship' do

  #     visit students_path

  #     within("#student-#{default_student.id}") do
  #       find_link('View').click
  #     end

  #     within("#internship-#{internship.id}") do
  #       accept_confirm_dialog {
  #         find('.delete_student_internship', visible: true).click
  #       }
  #     end

  #     expect(page).to have_text 'Successfully deleted internship'
  #     expect(internship.where(category: 0).count).to eq 0
  #     end
  #   end
  # end
# end
