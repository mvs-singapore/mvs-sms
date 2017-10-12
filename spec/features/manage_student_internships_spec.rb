require 'rails_helper'

describe 'manage internship records', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }
  let!(:hilton_hotel) { create(:internship_company, name: 'Hilton Hotel') }
  let!(:milton_hotel) { create(:internship_company, name: 'Milton Hotel') }
  let!(:supervisor) { create(:internship_supervisor,
                      name: 'aaaa',
                      internship_company: hilton_hotel)}
  let!(:internship_record) do
    create(
      :internship_record,
      student: ali,
      internship_company: hilton_hotel,
      internship_supervisor: supervisor )
  end

  before do
    sign_in yammy
    visit edit_student_path(ali)
    click_link 'Internship Records'
  end

  it 'add a record', js: true do
    click_link 'Add Internship Record'
    within("#internship-records .nested-fields:nth-of-type(2)") do
      select('Hilton Hotel', from: 'Internship company')
      select('aaaa', from: 'Internship supervisor')
      fill_in 'From date', with: '01/02/2017'
      fill_in 'To date', with: '03/02/2017'
      fill_in 'Add comments', with: 'Good boy'
    end

    page.execute_script "window.scrollBy(0,1000)"
    click_button 'Update Student'

    expect(page).to have_text 'Successfully updated student'
    expect(ali.internship_records.count).to eq 2
  end

  it 'edit a record', js: true do
    within("#internship-records .nested-fields:nth-of-type(1)") do
      fill_in 'Add comments', with: 'Student slapped another student'
    end

    page.execute_script "window.scrollBy(0,1000)"
    click_button 'Update Student'

    expect(page).to have_text 'Successfully updated student'
    expect(internship_record.reload.comments).to eq 'Student slapped another student'
  end

  it 'delete a record', js: true do
    within("#internship-records .nested-fields:nth-of-type(1)") do
      accept_confirm_dialog {
        page.execute_script "window.scrollBy(0,1000)"
        find('.delete_internship_record', visible: true).click
      }
    end

    click_button 'Update Student'
    ali.reload
    expect(ali.internship_records.count).to eq 0
  end
end
