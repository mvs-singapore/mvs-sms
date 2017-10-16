require 'rails_helper'

describe 'manage teacher dashboard', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }
  let!(:fnb_class) { create(:school_class, form_teacher_id: yammy.id, student_ids: ali.id) }

  before do
    sign_in yammy
    visit root_path
  end

  it 'view teacher dashboard', js: true do
    within("#school-class-#{fnb_class.id}") do
      expect(find('td[data-for="academic_year"]')).to have_content '2017'
      expect(find('td[data-for="class"]')).to have_content 'Year 2 Food & Beverages'
      expect(find('td[data-for="form_class"]')).to have_css('.fa-check-circle')
    end
  end

  it 'view individual class', js: true do
    within("#school-class-#{fnb_class.id}") do
      find('td[data-for="class"]').find(".school_class-name").click
    end

    expect(find('h1')).to have_content 'Year 2 Food & Beverages (2017), yammy (Form Teacher)'

    within("#student-#{ali.id}") do
      expect(find('td[data-for="academic_year"]')).to have_content '2017'
      expect(find('td[data-for="class"]')).to have_content 'Year 2 Food & Beverages'
      expect(find('td[data-for="full_name"]')).to have_content 'Lee, Ali'
    end
  end
end
