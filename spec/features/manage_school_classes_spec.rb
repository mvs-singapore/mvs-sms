require 'rails_helper'

describe 'manage school classes', type: :feature do
  let!(:super_admin_role) { Role.create(name: 'super_admin', super_admin: true) }
  let!(:super_user) { User.create(email: 'admin@example.com', password: 'password', name: 'Super Admin', role: super_admin_role) }

  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }

  before do
    sign_in super_user
  end

  describe 'create class' do
    it 'creates new class' do
      visit '/admin/school_classes/'
      click_link 'Add Class'

      within('#new_school_class') do
        fill_in 'Academic Year', with: '2017'
        fill_in 'Name', with: 'Class 1.1'
        select('Year 1', from: 'Year')
        select(teacher_user.name, from: 'Form Teacher')
      end

      click_button 'Create School class'

      expect(page).to have_text 'Successfully created school class'
      expect(page).to have_text teacher_user.name

      new_class = SchoolClass.last
      expect(new_class.name).to eq 'Class 1.1'
      expect(new_class.academic_year).to eq 2017
      expect(new_class.year).to eq 1
      expect(new_class.form_teacher.id).to eq teacher_user.id
    end
  end

  describe 'edit class' do
    let!(:fnb_class) { SchoolClass.create(academic_year: 2017,
                                           name: 'Year 2 Food & Beverages',
                                           year: 2,
                                           form_teacher: teacher_user)
    }

    it 'edits an existing class' do
      visit '/admin/school_classes/'

      within("#class-#{fnb_class.id}") do
        find_link('Edit').click
      end
      within('.edit_school_class') do
        fill_in 'Name', with: 'Year 2 F&B'
      end
      click_button 'Update School class'

      expect(page).to have_text 'Successfully updated school class'

      expect(fnb_class.reload.name).to eq 'Year 2 F&B'
    end
  end

  describe 'view class' do
    let!(:fnb_class) { SchoolClass.create(academic_year: 2017,
                                          name: 'Year 2 Food & Beverages',
                                          year: 2,
                                          form_teacher: teacher_user)
    }

    it 'displays class details' do
      visit '/admin/school_classes/'

      within("#class-#{fnb_class.id}") do
        find_link('View').click
      end

      expect(find('h1')).to have_content 'Year 2 Food & Beverages (2017), Good Teacher (Form Teacher)'
    end
  end

  describe 'delete class', js: true do
    let!(:closed_class) { SchoolClass.create(academic_year: 2017,
                                              name: 'Year 2 Nose Picking',
                                              year: 2,
                                              form_teacher: teacher_user)
    }

    it 'deletes an existing class' do
      visit '/admin/school_classes/'

      within("#class-#{closed_class.id}") do
        accept_confirm_dialog {
          find('.delete_school_class', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted school class'
      expect(SchoolClass.where(name: 'Year 2 Nose Picking').count).to eq 0
    end
  end
end
