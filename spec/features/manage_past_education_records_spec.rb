require 'rails_helper'

describe 'manage past education records', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }
  let!(:primary_edu) { create(:past_education_record,
                              school_name: 'Northlight',
                              student: ali) }

  before do
    sign_in yammy
    visit edit_student_path(ali)
    click_link 'Administrative Details'
  end

  it 'edit student past education record', js: true do
    within('#past-educations .nested-fields:nth-of-type(1)') do
      find('td[data-for="school_name"] input').set('Another School')
    end

    click_button 'Update Student'

    expect(page).to have_text 'Successfully updated student'
    expect(primary_edu.reload.school_name).to eq 'Another School'
  end

  it 'delete student past education record', js: true do
    within('#past-educations .nested-fields:nth-of-type(1)') do
      accept_confirm_dialog {
        find('.delete_past_education_record', visible: true).click
      }
    end
    click_button 'Update Student'
    ali.reload
    expect(ali.past_education_records.count).to eq 0
  end
end
