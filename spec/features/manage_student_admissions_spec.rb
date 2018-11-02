require 'rails_helper'

describe 'new student admissions', type: :feature do
  let!(:yammy) { create(:yammy) }
  let!(:ali) { create(:student) }
  let!(:autistic_disability) { Disability.create(title: "Autistic")}
  let!(:disability) { Disability.create(title: "Down's Syndrome")}
  let!(:epilepsy_medical_condition) {MedicalCondition.create(title: "Epilepsy")}
  let!(:medical_condition) {MedicalCondition.create(title: "Asthma")}
  let!(:cohort) { create(:school_class, form_teacher_id: yammy.id) }
  let!(:student_class) {StudentClass.create(student_id: ali.id, school_class_id: cohort.id)}

  before do
    sign_in yammy
  end

  describe 'create student', js: true do
    it 'creates new student' do
      visit students_path
      click_link 'Students'
      click_link 'Add New Student'

      page.execute_script "window.scrollTo(0,0)"

      within('#student-particulars') do
        fill_in 'Surname', with: 'Lee'
        fill_in 'Given Name', with: 'Ali'
        fill_in 'Date of Birth', with: '1997-09-09'
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Race', with: 'Chinese'
        fill_in 'NRIC', with: 'S8888888D'
        fill_in 'Citizenship', with: 'Singaporean'
        select('Female', from: 'Gender')
        select('M', from: 'T-shirt Size')
        fill_in 'SADeaf Client Registration No.', with: '12445/244'
        find('#student_place_of_birth').click
      end

      within('#student-medical-history') do
        fill_in 'Medication Needed', with: 'Antihistamines'
        fill_in 'Allergies', with: 'Peanuts'
        chosen_select('Autistic', "Down's Syndrome", from: 'Disabilities')
        chosen_select('Epilepsy', "Asthma", from: 'Medical Conditions')
      end

      page.execute_script "window.scrollTo(0,0)"
      click_link 'Administrative Details'

      within('#admission-details') do
        fill_in 'Admission Year', with: '2017'
        fill_in 'Admission No.', with: '16006/2016'
        fill_in 'Date of Registration', with: '2017-09-09'
        select('Association of Persons with Special Needs', from: 'Referred By')
        fill_in 'Name of Referee', with: 'Mdm Referee'
      end

      within('#past-educations .nested-fields:nth-of-type(1)') do
        find('td[data-for="school_name"] input').set('Northlight')
        find('td[data-for="from_date"] input').set('2016-03-02')
        find('td[data-for="to_date"] input').set('2017-03-02')
        find('td[data-for="qualification"] input').set('GCE O Levels')
        find('td[data-for="highest_qualification"] input').set(true)
      end

      within('#student-financial-assistance .nested-fields:nth-of-type(1)') do
        find('td[data-for="assistance_type"] input').set('Pocket Fund')
        find('td[data-for="year_obtained"] input').set('2017')
        find('td[data-for="duration"] input').set('1 year')
      end

      page.execute_script "window.scrollTo(0,0)"
      click_link 'Parent/Guardian Particulars'

      within('#contacts .nested-fields:nth-of-type(1)') do
        fill_in 'Surname', with: 'Ong'
        fill_in 'Given Name', with: 'Pearly'
        fill_in 'Address', with: '5 Smith Street'
        fill_in 'Postal Code', with: '987654'
        fill_in 'Race', with: 'Chinese'
        fill_in 'Dialect', with: 'Teochew'
        fill_in 'Languages Spoken', with: 'English'
        fill_in 'ID Number', with: 'S8888888D'
        select('blue', from: 'ID Type')
        fill_in 'Date of Birth', with: '2000-01-01'
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Nationality', with: 'Singaporean'
        fill_in 'Occupation', with: 'Clerk'
        fill_in 'Home Number', with: '65556555'
        fill_in 'Handphone Number', with: '87778777'
        fill_in 'Office Number', with: '61116111'
        fill_in 'Relationship', with: 'Mother'
      end

      page.execute_script "window.scrollBy(0,1000)"
      click_button 'Create Student'

      expect(page).to have_text 'Successfully created student'
      expect(page).to have_text 'Ali'
      new_student = Student.last

      within("#student-#{new_student.id}") do
        expect(find('td[data-for="full_name"]')).to have_content 'Lee, Ali'
        expect(find('td[data-for="date_of_birth"]')).to have_content '1997-09-09'
        expect(find('td[data-for="gender"]')).to have_content 'Female'
        expect(find('td[data-for="status"]')).to have_content 'New Admission'
        expect(find('td[data-for="disabilities"]')).to have_content("Autistic")
        expect(find('td[data-for="medical_conditions"]')).to have_content("Asthma")
      end

      within("#student-#{new_student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end

      within("#student-details-#{new_student.id}") do
        expect(find('dd[data-for="medical_conditions"]')).to have_content "Epilepsy"
        expect(find('dd[data-for="medical_conditions"]')).to have_content "Asthma"
        expect(find('dd[data-for="disabilities"]')).to have_content "Down's Syndrome"
        expect(find('dd[data-for="disabilities"]')).to have_content "Autistic"
        expect(find('dd[data-for="medication_needed"]')).to have_content "Antihistamines"
        expect(find('dd[data-for="allergies"]')).to have_content "Peanuts"
        expect(find('dd[data-for="relationship"]')).to have_content "Mother"
        expect(find('dd[data-for="home_number"]')).to have_content "65556555"
        expect(find('dd[data-for="handphone_number"]')).to have_content "87778777"
        expect(find('dd[data-for="office_number"]')).to have_content "61116111"
      end

      expect(new_student.admission_no).to eq '16006/2016'
      expect(new_student.registered_at).to eq Date.parse('09/09/2017')
      expect(new_student.referred_by).to eq 'association_of_persons_with_special_needs'
      expect(new_student.referral_notes).to eq 'Mdm Referee'
      expect(new_student.status).to eq 'New Admission'
      expect(new_student.place_of_birth).to eq 'Singapore'
      expect(new_student.race).to eq 'Chinese'
      expect(new_student.nric).to eq 'S8888888D'
      expect(new_student.citizenship).to eq 'Singaporean'
      expect(new_student.sadeaf_client_reg_no).to eq '12445/244'
      expect(new_student.medication_needed).to eq 'Antihistamines'
      expect(new_student.allergies).to eq 'Peanuts'
      expect(new_student.tshirt_size).to eq 'M'
      expect(new_student.point_of_contacts.count).to eq 1
      expect(new_student.point_of_contacts.last.surname).to eq 'Ong'
      expect(new_student.point_of_contacts.last.given_name).to eq 'Pearly'
      expect(new_student.point_of_contacts.last.address).to eq '5 Smith Street'
      expect(new_student.point_of_contacts.last.postal_code).to eq '987654'
      expect(new_student.point_of_contacts.last.race).to eq 'Chinese'
      expect(new_student.point_of_contacts.last.dialect).to eq 'Teochew'
      expect(new_student.point_of_contacts.last.languages_spoken).to eq 'English'
      expect(new_student.point_of_contacts.last.id_number).to eq 'S8888888D'
      expect(new_student.point_of_contacts.last.id_type).to eq 'blue'
      expect(new_student.point_of_contacts.last.date_of_birth).to eq Date.new(2000,1,1)
      expect(new_student.point_of_contacts.last.place_of_birth).to eq 'Singapore'
      expect(new_student.point_of_contacts.last.nationality).to eq 'Singaporean'
      expect(new_student.point_of_contacts.last.occupation).to eq 'Clerk'
      expect(new_student.point_of_contacts.last.home_number).to eq '65556555'
      expect(new_student.point_of_contacts.last.handphone_number).to eq '87778777'
      expect(new_student.point_of_contacts.last.office_number).to eq '61116111'
      expect(new_student.point_of_contacts.last.relationship).to eq 'Mother'

      expect(new_student.disabilities.first.title).to eq 'Autistic'
      expect(new_student.disability_ids).to include(autistic_disability.id, disability.id)
      expect(new_student.medical_conditions.first.title).to eq 'Epilepsy'
      expect(new_student.medical_condition_ids).to include(medical_condition.id, epilepsy_medical_condition.id)
    end
  end

  describe 'edit student', js: true do
    before do
      ali.student_disabilities.create(disability: disability)
      ali.student_disabilities.create(disability: autistic_disability)
      ali.student_medical_conditions.create(medical_condition: medical_condition)
      ali.student_medical_conditions.create(medical_condition: epilepsy_medical_condition)
    end

    it 'edits admission details' do
      visit edit_student_path(ali)

      within('.edit_student') do
        click_link 'Administrative Details'
        fill_in 'Admission Year', with: 2017
      end

      page.execute_script "window.scrollBy(0,10000)"
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(ali.reload.admission_year).to eq 2017
    end

    it 'edits medical conditions in student details' do
      visit edit_student_path(ali)

      page.execute_script "window.scrollBy(0,600)"
      within('#student-medical-history') do
        chosen_unselect('Autistic', from: 'Disabilities')
        chosen_unselect('Epilepsy', from: 'Medical Conditions')
      end

      page.execute_script "window.scrollBy(0,10000)"
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(ali.reload.disabilities.first.title).to eq "Down's Syndrome"
      expect(ali.reload.disability_ids).to include(disability.id, disability.id)

      expect(ali.reload.medical_conditions.first.title).to eq 'Asthma'
      expect(ali.reload.medical_condition_ids).to include(medical_condition.id, medical_condition.id)
    end
  end

  describe 'view student' do
    before do
      t = Time.parse("25 December 2017") # Fix to 2017 so the age calculation is based on a fixed point in time
      Timecop.travel(t)
    end

    after do
      Timecop.return
    end

    it 'displays the details of a student' do
      visit student_path(ali)

      expect(page).to have_link 'Edit'

      expect(find('dd[data-for="given_name"]')).to have_content 'Ali'
      expect(find('dd[data-for="surname"]')).to have_content 'Lee'
      expect(find('dd[data-for="gender"]')).to have_content 'Female'
      expect(find('dd[data-for="date_of_birth"]')).to have_content '1997-09-09'
      expect(find('dd[data-for="age"]')).to have_content '20'
      expect(find('dd[data-for="citizenship"]')).to have_content 'Singaporean'
      expect(find('dd[data-for="race"]')).to have_content 'Chinese'
      expect(find('dd[data-for="nric"]')).to have_content 'S8888888D'
    end
  end

  describe 'delete student', js: true do

    it 'deletes an existing student' do
      visit students_path

      within("#student-#{ali.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{ali.id}") do
        accept_confirm_dialog {
          find('.delete_student', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted student'
      expect(Student.where(given_name: 'Ali', surname: 'Lee').count).to eq 0
    end
  end

  describe 'search student', js: true do
    let!(:robin) { create(:student, given_name: 'Robin') }
    let!(:cohort2) {SchoolClass.create(academic_year: 2016, name: 'Class 1.1', year: 1, form_teacher_id: yammy.id)}

    it 'searches students by academic year and class' do
      visit students_path
      select('2017', from: 'academic_year')
      expect(find('select#class_name')).to_not have_content 'Class 1.1'
      select('Year 2 Food & Beverages', from: 'class_name')
      click_on 'Search by Academic Year or Class'

      expect(find('td[data-for="full_name"]')).to have_content 'Ali'
      expect(find('td[data-for="full_name"]')).to_not have_content 'Robin'
    end

    it 'searches students by name' do
      visit students_path
      fill_in "search", with: "Robin"
      click_on 'Search by Name'

      expect(find('td[data-for="full_name"]')).to have_content 'Robin'
    end
  end
end
