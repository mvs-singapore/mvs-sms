require 'rails_helper'

describe 'manage past education records', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:student) { Student.create(admission_year: 2016, admission_no: '16006/2016', registered_at: Date.parse('09/09/2017'),
                                  status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', surname: 'Lee',
                                  given_name: 'Ali', date_of_birth: Date.parse('09/09/1997'), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female')
  }
  let!(:past_education_record) { PastEducationRecord.create(school_name: 'Northlight', from_date: Date.new(1990,1,1),
                                                            to_date: Date.new(1995,1,1), highest_qualification: true, student: student)
  }

  before do
    sign_in teacher_user
  end

  describe 'edit student past education record', js: true do
    it 'edits past education record' do
      visit students_path

      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('Edit').click
      end

      page.execute_script "window.scrollTo(0,0)"

      click_link 'Past Education Records'
      within('#past-educations .nested-fields:nth-of-type(1)') do
        find('td[data-for="school_name"] input').set('Another School')
      end

      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(past_education_record.reload.school_name).to eq 'Another School'
    end
  end

  describe 'delete student past education record', js: true do
    before do
      second_record = { school_name: 'Primary School', from_date: Date.new(1990,1,1), to_date: Date.new(1995,1,1), highest_qualification: false }
      student.past_education_records.create(second_record)
    end
    it 'deletes past education record' do
      visit students_path
      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('Edit').click
      end
      page.execute_script "window.scrollTo(0,0)"

      click_link 'Past Education Records'
      within('#past-educations .nested-fields:nth-of-type(2)') do
        accept_confirm_dialog {
          find('.delete_past_education_record', visible: true).click
        }
      end
      click_button 'Update Student'
      student.reload
      expect(student.past_education_records.count).to eq 1
    end
  end
end
