require 'rails_helper'

xdescribe 'manage student classes', type: :feature do
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password', name: 'Super Admin', role: super_admin_role) }

  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }

  before do
    sign_in super_user
    visit '/admin/classes/'
  end

  describe 'create class' do
    it 'creates new class' do
      click_link 'Add Class'

      within('#new_class') do
        fill_in 'Academic Year', with: '2017'
        fill_in 'Name', with: 'Class 1.1'
        select('Year 1', from: 'Year')
        select(teacher_user.name, from: 'Form Teacher')
      end

      click_button 'Create Class'

      expect(page).to have_text 'Successfully created class'
      new_class = StudentClass.last
      expect(new_class.name).to eq 'Class 1.1'
      expect(new_class.academic_year).to eq 2017
      expect(new_class.year).to eq 1
      expect(new_class.form_teacher.id).to eq teacher_user.id
    end
  end

  describe 'edit class' do
    let!(:fnb_class) { StudentClass.create(academic_year: 2017,
                                           name: 'Year 2 Food & Beverages',
                                           year: 2,
                                           form_teacher: teacher_user)
    }

    it 'edits an existing class' do
      find_link(fnb_class.name, visible: true).click

      within('.edit_class') do
        fill_in 'Name', with: 'Year 2 F&B'
      end
      click_button 'Update Class'

      expect(page).to have_text 'Successfully updated class'

      expect(fnb_class.reload.name).to eq 'Year 2 F&B'
    end
  end

  describe 'delete class' do
    let!(:closed_class) { StudentClass.create(academic_year: 2017,
                                              name: 'Year 2 Nose Picking',
                                              year: 2,
                                              form_teacher: teacher_user)
    }

    it 'deletes an existing class' do
      within("class-#{closed_class.id}") do
        accept_confirm_dialog {
          find_link('delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted class'
      expect(StudentClass.where(name: 'Year 2 Nose Picking').count).to eq 0
    end
  end
end