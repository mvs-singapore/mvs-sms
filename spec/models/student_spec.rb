require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:admission_year) }
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
end
