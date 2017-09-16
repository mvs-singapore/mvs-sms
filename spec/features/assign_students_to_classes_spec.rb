require 'rails_helper'

describe 'assign students to classes', type: :feature do
  let!(:principal_role) { Role.create(name: 'principal', super_admin: true) }
  let!(:principal_user) { User.create(email: 'ernest@example.com', password: 'password', name: 'Principal Ernest', role: principal_role) }

  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }

  let!(:fnb_class) { SchoolClass.create(academic_year: 2017,
                                        name: 'Year 2 Food & Beverages',
                                        year: 2,
                                        form_teacher: teacher_user) }

  let!(:student) { Student.create(admission_year: 2017, registered_at: Date.new(2017,02,03), referred_by: 'Some Random School',
                                  surname: 'Smith', given_name: 'John', status: 'new_admission', place_of_birth: 'Singapore', citizenship: 'Singaporean',
                                  date_of_birth: Date.new(1995,02,03), race: 'Chinese', nric: '6589264', gender: 'male') }

  before do
    sign_in principal_user
    visit admin_school_classes_path
  end

  it 'adds/removes student from class' do
    within("#class-#{fnb_class.id}") do
      click_link 'Edit'
    end

    within('.edit_school_class') do
      select 'Smith, John', from: 'Students'
    end

    click_button 'Update School class'

    within("#class-#{fnb_class.id}") do
      click_link 'View'
    end

    expect(find('table[data-for="students"]')).to have_content 'Smith, John'

    click_link 'Edit'

    within('.edit_school_class') do
      unselect 'Smith, John', from: 'Students'
    end

    click_button 'Update School class'

    within("#class-#{fnb_class.id}") do
      click_link 'View'
    end

    expect(find('table[data-for="students"]')).to_not have_content 'Smith, John'
  end
end
