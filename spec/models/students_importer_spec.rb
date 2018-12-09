require 'rails_helper'

RSpec.describe StudentsImporter do
  describe 'execute' do
    before do
      FactoryBot.create(:yammy)
      FactoryBot.create(:student, nric: 'A1234567Z')
    end

    it 'raise error when filepath not found' do
      importer = StudentsImporter.new('/some/non/existence/path')
      expect { importer.execute }.to raise_error { |error|
        expect(error).to be_a(Errno::ENOENT)
      }  
    end

    it 'imports data into db' do
      path = Rails.root.join('spec/fixtures/2018_students.csv')
      importer = StudentsImporter.new(path)
      importer.execute

      student1 = Student.find_by(nric: 'T0000000B')

      expect(Student.count).to eq 2
      expect(student1.admission_no).to eq '18001 / 2018'
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

      student2 = Student.find_by(nric: 'A1234567Z')
      expect(student2.admission_no).to eq '18002 / 2018'
      expect(student2.admission_year).to eq 2018
      expect(student2.current_class.name).to eq '1.1'
      expect(student2.surname).to eq 'Morthy'
      expect(student2.given_name).to eq 'Krishnan'
      expect(student2.date_of_birth.to_s).to eq '1997-02-01'
      expect(student2.point_of_contacts.count).to eq 3
      expect(student2.point_of_contacts.pluck(:salutation)).to contain_exactly('Mdm', 'Mr', 'Mdm')
      expect(student2.point_of_contacts.pluck(:given_name)).to contain_exactly('Krishana', 'Krishnan', 'Marie')
      expect(student2.point_of_contacts.pluck(:surname)).to contain_exactly('Raja', 'Anu', 'Anne')
      expect(student2.point_of_contacts.pluck(:relationship)).to contain_exactly('Father', 'Mother', 'Auntie')
      expect(student2.point_of_contacts.pluck(:email)).to include('anne@gmail.com')
    end
  end
end
