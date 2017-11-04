require 'rails_helper'

describe 'track student status', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }

  before do
    sign_in yammy
    visit edit_student_path(ali)
  end

  it 'displays history of student status', js: true do
    page.execute_script "window.scrollBy(0,500)"
    within('#student-admission') do
      select('internship', from: 'Status')
    end

    click_button 'Update Student'
    expect(page).to have_text 'Successfully updated student'
    expect(ali.versions.last.created_at).to be_within(1).of(Time.now)

    within("#version-1") do
      expect(find('td[data-for="status_change_name"]')).to have_content 'yammy'
      expect(find('td[data-for="status_change"]')).to have_content 'From New Admission to Internship'
    end
  end
end
