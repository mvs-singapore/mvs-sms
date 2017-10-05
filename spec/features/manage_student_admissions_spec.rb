require 'rails_helper'

describe 'new student admissions', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher', super_admin: false) }
  let!(:teacher_user) { User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role) }
  let!(:student) { Student.create(admission_year: 2016, admission_no: '16006/2016', registered_at: Date.parse('09/09/2017'), current_class: 'Food & Beverage',
                                  status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', referral_notes: 'Mdm Referee',
                                  surname: 'Lee', given_name: 'Ali', date_of_birth: Date.parse('09/09/1997'), place_of_birth: 'Singapore', race: 'Chinese',
                                  nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female', sadeaf_client_reg_no: '12345/234',
                                  medication_needed: 'Antihistamines', allergies: 'Peanuts')
  }
  let!(:autistic_disability) { Disability.create(title: "Autistic")}
  let!(:disability) { Disability.create(title: "Down's Syndrome")}
  let!(:epilepsy_medical_condition) {MedicalCondition.create(title: "Epilepsy")}
  let!(:medical_condition) {MedicalCondition.create(title: "Asthma")}
  let!(:cohort) {SchoolClass.create(academic_year: 2016, name: 'Class 1.1', year: 1, form_teacher_id: teacher_user.id)}
  let!(:student_class) {StudentClass.create(student_id: student.id, school_class_id: cohort.id)}

  before do
    sign_in teacher_user
  end

  describe 'create student', js: true do
    it 'creates new student' do
      visit students_path
      click_link 'Students'
      click_link 'Add New Student'

      fill_in 'Admission Year', with: '2017'
      fill_in 'Admission No.', with: '16006/2016'
      fill_in 'Date of Registration', with: '09/09/2017'
      select('new_admission', from: 'Status')
      select('association_of_persons_with_special_needs', from: 'Referred By')
      fill_in 'Name of Referee', with: 'Mdm Referee'

      click_link 'Student Particulars'
      within('#student-particulars') do

        fill_in 'Surname', with: 'Lee'
        fill_in 'Given Name', with: 'Ali'
        fill_in 'Date of Birth', with: '09/09/1997'
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Race', with: 'Chinese'
        fill_in 'NRIC', with: 'S8888888D'
        fill_in 'Citizenship', with: 'Singaporean'
        select('female', from: 'Gender')
        fill_in 'SADeaf Client Registration No.', with: '12345/234'

        find('#student_place_of_birth').click

        fill_in 'Medication Needed', with: 'Antihistamines'
        fill_in 'Allergies', with: 'Peanuts'
        chosen_select('Autistic', "Down's Syndrome", from: 'Disabilities')
        chosen_select('Epilepsy', "Asthma", from: 'Medical Conditions')
      end
      page.execute_script "window.scrollTo(0,0)"

      click_link 'Past Education Records'
      within('#past-educations .nested-fields:nth-of-type(1)') do
        find('td[data-for="school_name"] input').set('Northlight')
        find('td[data-for="from_date"] input').set('02/03/2016')
        find('td[data-for="to_date"] input').set('02/03/2017')
        find('td[data-for="qualification"] input').set('GCE O Levels')
        find('td[data-for="highest_qualification"] input').set(true)
      end

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
        fill_in 'Date of Birth', with: '01/01/2000'
        fill_in 'Place of Birth', with: 'Singapore'
        fill_in 'Nationality', with: 'Singaporean'
        fill_in 'Occupation', with: 'Clerk'
        fill_in 'Home Number', with: '65556555'
        fill_in 'Handphone Number', with: '87778777'
        fill_in 'Office Number', with: '61116111'
        fill_in 'Relationship', with: 'Mother'
      end

      page.execute_script "window.scrollBy(0,10000)"
      click_button 'Create Student'

      expect(page).to have_text 'Successfully created student'
      expect(page).to have_text 'Ali'
      new_student = Student.last

      within("#student-#{new_student.id}") do
        expect(find('td[data-for="given_name"]')).to have_content 'Ali'
        expect(find('td[data-for="surname"]')).to have_content 'Lee'
        expect(find('td[data-for="date_of_birth"]')).to have_content Date.new(1997,9,9)
        expect(find('td[data-for="gender"]')).to have_content 'female'
        expect(find('td[data-for="status"]')).to have_content 'new_admission'
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
      expect(new_student.place_of_birth).to eq 'Singapore'
      expect(new_student.race).to eq 'Chinese'
      expect(new_student.nric).to eq 'S8888888D'
      expect(new_student.citizenship).to eq 'Singaporean'
      expect(new_student.sadeaf_client_reg_no).to eq '12345/234'
      expect(new_student.medication_needed).to eq 'Antihistamines'
      expect(new_student.allergies).to eq 'Peanuts'
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
      student.student_disabilities.create(disability: disability)
      student.student_disabilities.create(disability: autistic_disability)
      student.student_medical_conditions.create(medical_condition: medical_condition)
      student.student_medical_conditions.create(medical_condition: epilepsy_medical_condition)
    end

    it 'edits admission details' do
      visit students_path

      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('Edit').click
      end
      within('.edit_student') do
        fill_in 'Admission Year', with: 2017
      end
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(student.reload.admission_year).to eq 2017
    end

    it 'edits medical conditions in student details' do
      visit students_path

      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('Edit').click
      end

      click_link 'Student Particulars'
      within('#student-particulars') do
        page.execute_script "window.scrollBy(0,10000)"
        chosen_unselect('Autistic', from: 'Disabilities')
        chosen_unselect('Epilepsy', from: 'Medical Conditions')
      end
      click_button 'Update Student'

      expect(page).to have_text 'Successfully updated student'
      expect(student.reload.disabilities.first.title).to eq "Down's Syndrome"
      expect(student.reload.disability_ids).to include(disability.id, disability.id)

      expect(student.reload.medical_conditions.first.title).to eq 'Asthma'
      expect(student.reload.medical_condition_ids).to include(medical_condition.id, medical_condition.id)
    end

    describe 'deletes past education record' do
      before do
        first_record = { school_name: 'Northlight School', from_date: Date.new(1990,1,1), to_date: Date.new(1995,1,1), highest_qualification: true }
        second_record = { school_name: 'Primary School', from_date: Date.new(1990,1,1), to_date: Date.new(1995,1,1), highest_qualification: false }
        student.past_education_records.create(first_record)
        student.past_education_records.create(second_record)
      end
      it 'deletes past education record from edit page' do

        visit students_path
        within("#student-#{student.id}") do
          find('td[data-for="view"]').find(".fa").click
        end
        within("#student-details-#{student.id}") do
          find_link('Edit').click
        end

        click_link 'Past Education Records'
        within('#past-educations .nested-fields:nth-of-type(2)') { find_link('Delete Record').click }
          sleep(1)
        click_button 'Update Student'
        student.reload
        expect(student.past_education_records.count).to eq 1
      end
    end


    describe 'delete point of contacts' do
      before do
        papa = { surname: 'Doe', given_name: 'John', handphone_number: '12345678', relationship: 'Father' }
        mama = { surname: 'Doe', given_name: 'Jean', handphone_number: '12345678', relationship: 'Mother' }
        student.point_of_contacts.create(papa)
        student.point_of_contacts.create(mama)
      end
      it 'deletes point of contacts' do

        visit students_path
        within("#student-#{student.id}") do
          find('td[data-for="view"]').find(".fa").click
        end
        within("#student-details-#{student.id}") do
          find_link('Edit').click
        end

        click_link 'Parent/Guardian Particulars'
        within('#contacts .nested-fields:nth-of-type(1)') { find_link('Delete Contact').click }
        sleep(1)
        page.execute_script "window.scrollBy(0,10000)"
        click_button 'Update Student'
        student.reload
        expect(student.point_of_contacts.count).to equal 1
      end
    end
  end


  describe 'view student' do
    it 'displays the details of a student' do
      visit students_path

      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        find_link('View').click
      end

      expect(page).to have_link 'Edit'

      expect(find('dd[data-for="given_name"]')).to have_content 'Ali'
      expect(find('dd[data-for="surname"]')).to have_content 'Lee'
      expect(find('dd[data-for="gender"]')).to have_content 'female'
      expect(find('dd[data-for="date_of_birth"]')).to have_content '1997-09-09'
      expect(find('dd[data-for="gender"]')).to have_content 'female'
      expect(find('dd[data-for="age"]')).to have_content '20'
      expect(find('dd[data-for="citizenship"]')).to have_content 'Singaporean'
      expect(find('dd[data-for="race"]')).to have_content 'Chinese'
      expect(find('dd[data-for="nric"]')).to have_content 'S8888888D'
    end
  end

  describe 'delete student', js: true do

    it 'deletes an existing student' do
      visit students_path

      within("#student-#{student.id}") do
        find('td[data-for="view"]').find(".fa").click
      end
      within("#student-details-#{student.id}") do
        accept_confirm_dialog {
          find('.delete_student', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted student'
      expect(Student.where(given_name: 'Ali', surname: 'Lee').count).to eq 0
    end
  end

  describe 'search student', js: true do
    let!(:student2) { Student.create(admission_year: 2016, admission_no: '16006/2016', registered_at: Date.parse('09/09/2017'), current_class: 'Food & Beverage',
                                status: 'new_admission', referred_by: 'association_of_persons_with_special_needs', referral_notes: 'Mdm Referee',
                                surname: 'Lee', given_name: 'Robin', date_of_birth: Date.parse('09/09/1997'), place_of_birth: 'Singapore', race: 'Chinese',
                                nric: 'S8888888D', citizenship: 'Singaporean', gender: 'female', sadeaf_client_reg_no: '12345/234',
                                medication_needed: 'Antihistamines', allergies: 'Peanuts')
    }

    it 'searches students by academic year and class' do
      visit students_path
      select('2016', from: 'academic_year')
      select('Class 1.1', from: 'class_name')
      click_on 'Search by Academic Year or Class'

      expect(find('td[data-for="given_name"]')).to have_content 'Ali'
      expect(find('td[data-for="given_name"]')).to_not have_content 'Robin'
    end

    it 'searches students by name' do
      visit students_path
      fill_in "search", with: "Robin"
      click_on 'Search by Name'

      expect(find('td[data-for="given_name"]')).to have_content 'Robin'
    end
  end
end
