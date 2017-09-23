require 'rails_helper'

describe 'manage student past education records', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:default_student) { Student.create(admission_year: 2016, registered_at: Date.new(2017,9,9), status: 'new_admission',
                                  referred_by: 'association_of_persons_with_special_needs', surname: 'Lim', given_name: 'Kate',
                                  date_of_birth: Date.new(1997,9,9), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female') }
  let!(:past_education_record) { PastEducationRecord.create(school_name: 'Northlight School', from_date: Date.new(2016,02,03),
                                                            to_date: Date.new(2017,02,03), qualification: 'GCE O Levels', student: default_student) }

  before do
    sign_in teacher_user
  end

  describe 'add student past education record within add past education record page' do
    it 'adds a past education record' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end

      find('.add_student_past_education_record').click

      within('.new_past_education_record') do
        fill_in 'School Attended', with: 'Vocational School'
        fill_in 'From Date', with: Date.new(2000,1,1)
        fill_in 'To Date', with: Date.new(2004,1,1)
        fill_in 'Qualification', with: 'Certificate II'
      end
      click_button 'Create Past education record'

      expect(page).to have_text 'Successfully created past education record'
      expect(PastEducationRecord.where(school_name: 'Vocational School').count).to eq 1
    end
  end

  describe 'edit student past education record within edit student page' do
    it 'edits an existing past education record' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('Edit').click
      end
      within('.edit_student') do
        fill_in 'School Attended', with: 'Primary School'
      end
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(past_education_record.reload.school_name).to eq 'Primary School'
    end
  end

  describe 'edit student past education record within edit past education record page' do
    it 'edits an existing past education record' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end
      within("#record-#{past_education_record.id}") do
        find_link('Edit').click
      end
      within('.edit_past_education_record') do
        fill_in 'Qualification', with: 'Certificate II'
      end
      click_button 'Update Past education record'

      expect(page).to have_text 'Successfully updated past education record'
      expect(past_education_record.reload.qualification).to eq 'Certificate II'
    end
  end

  describe 'view student past education records' do
    it 'displays the details of a students past education records' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'

      expect(find('dd[data-for="school_name"]')).to have_content 'Northlight School'
      expect(find('dd[data-for="from_date"]')).to have_content '2016-02-03'
      expect(find('dd[data-for="to_date"]')).to have_content '2017-02-03'
      expect(find('dd[data-for="qualification"]')).to have_content 'GCE O Levels'
    end
  end

  describe 'delete student past education record', js: true do
    it 'deletes an existing past education record' do
      visit students_path

      within("#student-#{default_student.id}") do
        find_link('View').click
      end

      within("#record-#{past_education_record.id}") do
        accept_confirm_dialog {
          find('.delete_student_past_education_record', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted past education record'
      expect(PastEducationRecord.where(school_name: 'Northlight School').count).to eq 0
    end
  end



end
