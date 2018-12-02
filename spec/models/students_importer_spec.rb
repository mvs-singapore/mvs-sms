require 'rails_helper'

RSpec.describe StudentsImporter do
  describe 'execute' do
    before do
      FactoryBot.create(:yammy)
    end

    it 'raise error when filepath not found' do
      importer = StudentsImporter.new('/some/non/existence/path')
      expect { importer.execute }.to raise_error { |error|
        expect(error).to be_a(Errno::ENOENT)
      }  
    end

    it 'imports data into db' do
      path = Rails.root.join('spec/fixtures/march_2018.csv')
      importer = StudentsImporter.new(path)
      importer.execute

      student1 = Student.find_by(nric: 'A1234567Z')
      student2 = Student.find_by(nric: 'A1111111Z')
      student3 = Student.find_by(nric: 'S9999999A')

      expect(Student.count).to eq 3
      expect(student1.admission_no).to eq '1'
      expect(student1.admission_year).to eq 2018
      expect(student1.current_class.name).to eq '1.1'
      expect(student1.surname).to eq 'Tan'
      expect(student1.given_name).to eq 'May Ling'
      expect(student1.date_of_birth.to_s).to eq '2000-11-15'
      expect(student1.place_of_birth).to eq 'Singapore'
      expect(student1.citizenship).to eq 'Singaporean'
      expect(student1.gender).to eq 'female'
      expect(student1.past_education_records[0].school_name).to eq 'Payar Lebar Methodist'
      expect(student1.point_of_contacts.count).to eq 2
      expect(student1.point_of_contacts.pluck(:salutation)).to contain_exactly('Mdm', 'Mr')
      expect(student1.point_of_contacts.pluck(:given_name)).to contain_exactly('B C', 'Li Li')
      expect(student1.point_of_contacts.pluck(:surname)).to contain_exactly('Lau', 'Tan')
    end
  end
end
