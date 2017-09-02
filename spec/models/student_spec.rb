require 'rails_helper'

RSpec.describe Student, type: :model do
  describe "new student" do
    it 'should have default status' do
      new_student = Student.create(admission_year: 2017, registered_at: Date.today, status: :new_admission)
      expect(new_student.reload.status).to eq 'new_admission'
    end
  end
end
