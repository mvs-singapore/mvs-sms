require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:admission_year) }
    it { is_expected.to validate_presence_of(:registered_at) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:referred_by) }
    it { is_expected.to validate_presence_of(:surname) }
    it { is_expected.to validate_presence_of(:given_name) }
    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:place_of_birth) }
    it { is_expected.to validate_presence_of(:race) }
    it { is_expected.to validate_presence_of(:nric) }
    it { is_expected.to validate_presence_of(:citizenship) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_numericality_of(:admission_year).only_integer }
  end

  describe 'associations' do
    it { is_expected.to have_many(:internship_records) }
    it { is_expected.to have_many(:past_education_records) }
    it { is_expected.to have_many(:point_of_contacts) }
    it { is_expected.to have_many(:remarks) }
    it { is_expected.to have_many(:student_classes) }
    it { is_expected.to have_many(:school_classes).through(:student_classes) }
    it { is_expected.to have_many(:student_disabilities) }
    it { is_expected.to have_many(:disabilities).through(:student_disabilities) }
    it { is_expected.to have_many(:student_medical_conditions) }
    it { is_expected.to have_many(:medical_conditions).through(:student_medical_conditions) }
    it { is_expected.to have_many(:student_status_histories) }
  end

  describe 'scopes' do
    describe 'sorted' do
      let!(:student_1) {
        Student.create(
            admission_year: 2017,
            registered_at: Date.today,
            status: :new_admission,
            referred_by: 'self_referred',
            surname: 'Li',
            given_name: 'Ah Hock',
            date_of_birth: Date.today,
            place_of_birth: 'Singapore',
            race: 'Chinese',
            nric: 'S80888888D',
            citizenship: 'Singaporean',
            gender: :male
        )
      }

      let!(:student_2) {
        Student.create(
            admission_year: 2017,
            registered_at: Date.today,
            status: :new_admission,
            referred_by: 'self_referred',
            surname: 'Chan',
            given_name: 'Hock Chye',
            date_of_birth: Date.today,
            place_of_birth: 'Singapore',
            race: 'Chinese',
            nric: 'S80888888D',
            citizenship: 'Singaporean',
            gender: :male
        )
      }

      it 'returns students sorted in alphabetical order of surname' do
        expect(Student.sorted).to eq [student_2, student_1]
      end
    end
  end

  describe "new student" do
    it 'should have default status' do
      new_student = Student.create(
          admission_year: 2017,
          registered_at: Date.today,
          status: :new_admission,
          referred_by: 'self_referred',
          surname: 'Li',
          given_name: 'Ah Hock',
          date_of_birth: Date.today,
          place_of_birth: 'Singapore',
          race: 'Chinese',
          nric: 'S80888888D',
          citizenship: 'Singaporean',
          gender: :male
        )
      expect(new_student.reload.status).to eq 'new_admission'
    end
  end

  describe '#full_name' do
    it 'should include given name and surname' do
      student = Student.create(
          admission_year: 2017,
          registered_at: Date.today,
          status: :new_admission,
          referred_by: 'self_referred',
          surname: 'Li',
          given_name: 'Ah Hock',
          date_of_birth: Date.today,
          place_of_birth: 'Singapore',
          race: 'Chinese',
          nric: 'S80888888D',
          citizenship: 'Singaporean',
          gender: :male
      )

      expect(student.full_name).to eq 'Li, Ah Hock'
    end
  end

  describe 'generate csv' do
    it 'creates a CSV for the specified content' do
      teacher_role = Role.create(name: 'teacher', super_admin: false)
      teacher_user = User.create(email: 'teacher1@example.com', password: 'password', name: 'Good Teacher', role: teacher_role)
      disabilities = Disability.create(title: "Autistic")
      medical_conditions = MedicalCondition.create(title: "Epilepsy")
      cohort = SchoolClass.create(academic_year: 2016, name: 'Class 1.1', year: 1, form_teacher_id: teacher_user.id)
      student = Student.create(
          admission_year: 2017,
          admission_no: '16006/2016',
          registered_at: Date.today,
          status: :new_admission,
          referred_by: 'association_of_persons_with_special_needs',
          surname: 'Li',
          given_name: 'Ah Hock',
          date_of_birth: Date.today,
          place_of_birth: 'Singapore',
          race: 'Chinese',
          nric: 'S80888888D',
          citizenship: 'Singaporean',
          gender: :male,
          sadeaf_client_reg_no: '12345/234',
          medication_needed: 'Antihistamines',
          allergies: 'Peanuts'
      )
      student.student_disabilities.create(disability: disabilities)
      student.student_medical_conditions.create(medical_condition: medical_conditions)
      student.student_classes.create(school_class_id: cohort.id)
      record = [student]
      expect(Student.as_csv(record)).to eq 'given_name,surname,admission_year,admission_no,registered_at,current_class,status,date_of_birth,place_of_birth,race,nric,citizenship,gender,sadeaf_client_reg_no,disabilities,medical_conditions,medication,allergies,referred_by
Ah Hock,Li,2017,16006/2016,2017-10-02,Class 1.1 (2016),new_admission,2017-10-02,Singapore,Chinese,S80888888D,Singaporean,male,12345/234,Autistic,Epilepsy,Antihistamines,Peanuts,association_of_persons_with_special_needs
'
    end
  end
end
