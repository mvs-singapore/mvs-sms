require 'rails_helper'

describe 'add remarks to student profile', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:default_student) { Student.create(admission_year: 2016, registered_at: Date.new(2017,9,9), status: 'new_admission',
                                  referred_by: 'association_of_persons_with_special_needs', surname: 'Lim', given_name: 'Kate',
                                  date_of_birth: Date.new(1997,9,9), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female') }
  let!(:remark) { Remark.create(event_date: Date.new(2017,02,03), category: 0, details: 'Student pushed another student',
                                                            student: default_student, user: teacher_user) }

  before do
    sign_in teacher_user
  end

  describe 'add remarks to student profile within edit student page' do
    it 'adds a remark to student profile' do
      visit students_path 

      within("#student-#{default_student.id}") do
        find_link('View').click
      end

      find('.add_student_remark').click

      within('.new_remark') do
        fill_in 'Event Date', with: Date.new(2017,02,03)
        fill_in 'Category', with: 3
        fill_in 'Details', with: 'Student pushed another student'
      end
      click_button 'Create Remark'

      expect(page).to have_text 'Successfully created remark'
      expect(Remark.where(category: 3).count).to eq 1
    end
  end

  describe 'edit remark within edit student page' do
    it 'edits an existing remark' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end
      within("#remark-#{remark.id}") do
        find_link('Edit').click
      end

      within('.edit_remark') do
        fill_in 'Details', with: 'Student slapped another student'
      end
      click_button 'Update Remark'

      expect(page).to have_text 'Successfully updated remark'
      expect(remark.reload.details).to eq 'Student slapped another student'
      end
    end

  describe 'view remarks' do
    it 'displays the details of a remark' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end
      remarks = page.find '#student_remarks'
      expect(remarks).to have_link 'Edit'
      expect(remarks).to have_link 'Delete'

      expect(find('#student_remarks dd[data-for="event_date"]')).to have_content '2017'
      expect(find('#student_remarks dd[data-for="category"]')).to have_content 0
      expect(find('#student_remarks dd[data-for="details"]')).to have_content 'Student'
    end
  end

  describe 'delete remark', js: true do
    it 'deletes an existing remark' do

      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end

      within("#remark-#{remark.id}") do
        accept_confirm_dialog {
          find('.delete_student_remark', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted remark'
      expect(Remark.where(category: 0).count).to eq 0
      end
    end
end
