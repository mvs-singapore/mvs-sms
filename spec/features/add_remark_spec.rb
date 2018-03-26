require 'rails_helper'

describe 'add remarks to student profile', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }

  before do
    ali.remarks.create(event_date: Date.new(2017,02,03), category: 'incident',
    details: 'Student pushed another student', user: yammy)
    sign_in yammy
    visit edit_student_path(ali)
    click_link 'Current Info'
  end

  it 'adds a remark to student profile', js: true do
    click_link 'Add Remark'

    within('#student-remarks .nested-fields:nth-of-type(2)') do
      fill_in 'Event Date', with: Date.new(2017,02,03)
      select('New Admission', from: 'Category')
      fill_in 'Details', with: 'Student pushed another student'
    end

    click_button 'Update Student'

    expect(page).to have_text 'Successfully updated student'
    expect(Remark.where(category: :new_admission).count).to eq 1
  end

  it 'deletes an existing remark', js: true do
    within('.card-body #student-remarks .nested-fields:nth-of-type(1)') do
      accept_confirm_dialog {
        page.execute_script "window.scrollBy(0,1000)"
        find('.delete_remark', visible: true).click
      }
    end

    click_button 'Update Student'

    expect(page).to have_text 'Successfully updated student'
    ali.reload
    expect(ali.remarks.count).to equal 0
  end
end
