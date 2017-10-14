require 'rails_helper'

describe 'financial assistance records', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }
  let!(:assistance_rec) { create(:financial_assistance_record,
                              student: ali) }

  before do
    sign_in yammy
    visit edit_student_path(ali)
    #click_link 'Past Education Records'
  end

  it 'edit financial assistance record', js: true do
    within('#student-financial-assistance .nested-fields:nth-of-type(1)') do
      find('td[data-for="assistance_type"] input').set('Straits Times')
      find('td[data-for="year_obtained"] input').set('2015')
      find('td[data-for="duration"] input').set('1 Year')
    end

    click_button 'Update Student'

    expect(page).to have_text 'Successfully updated student'
    expect(assistance_rec.reload.assistance_type).to eq 'Straits Times'
    expect(assistance_rec.reload.year_obtained).to eq '2015'
    expect(assistance_rec.reload.duration).to eq '1 Year'
  end

  it 'delete financial assistance record', js: true do
    page.execute_script "window.scrollBy(0,800)"
    within('#student-financial-assistance .nested-fields:nth-of-type(1)') do
      accept_confirm_dialog {
        page.execute_script "window.scrollBy(0,0)"
        find('.delete_financial_assistance_record', visible: true).click
      }
    end
    page.execute_script "window.scrollBy(0,800)"
    click_button 'Update Student'
    ali.reload
    expect(ali.financial_assistance_records.count).to eq 0
  end
end
