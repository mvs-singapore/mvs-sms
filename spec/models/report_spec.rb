require 'rails_helper'

RSpec.describe Report do
  describe '#search_students' do
    before(:each) do
      @template = {age: [''], gender: [''], citizenship: [''], status: [''], referred_by: ['']}
    end

    it 'returns no students for empty query' do
      report = Report.new

      result = report.search_students
      expect(result.count).to eq 0
    end

    it 'returns students of a certain age' do
      FactoryBot.create(:student, admission_no:  '16013/2016', date_of_birth: DateTime.now - 13.years)
      FactoryBot.create(:student, admission_no:  '16014/2016', date_of_birth: DateTime.now - 14.years)
      FactoryBot.create(:student, admission_no:  '16015/2016', date_of_birth: DateTime.now - 15.years)

      report = Report.new(@template.merge!(age: ['', '13', '15']))

      result = report.search_students
      expect(result.count).to eq 2
      expect(result.first.admission_no).to eq '16013/2016'
      expect(result.last.admission_no).to eq '16015/2016'
    end

    it 'returns students of a certain gender' do
      FactoryBot.create(:student, admission_no:  '16013/2016', gender: 'female')
      FactoryBot.create(:student, admission_no:  '16014/2016', gender: 'male')

      report = Report.new(@template.merge!(gender: ['', 'female']))

      result = report.search_students
      expect(result.count).to eq 1
      expect(result.first.admission_no).to eq '16013/2016'
    end

    it 'returns students of a certain nationality' do
      FactoryBot.create(:student, admission_no:  '16013/2016', citizenship: 'Singaporean')
      FactoryBot.create(:student, admission_no:  '16014/2016', citizenship: 'Malaysian')

      report = Report.new(@template.merge!(citizenship: ['', 'Singaporean']))

      result = report.search_students
      expect(result.count).to eq 1
      expect(result.first.admission_no).to eq '16013/2016'
    end

    it 'returns students of a certain status' do
      FactoryBot.create(:student, admission_no: '16013/2016', status: 'new_admission')
      FactoryBot.create(:student, admission_no: '16014/2016', status: 'year1')
      FactoryBot.create(:student, admission_no: '16015/2016', status: 'year2')

      report = Report.new(@template.merge!(status: ['', 'year1']))

      result = report.search_students
      expect(result.count).to eq 1
      expect(result.first.admission_no).to eq '16014/2016'
    end

    it 'returns students of a certain referral' do
      FactoryBot.create(:student, admission_no:  '16013/2016', referred_by: :association_of_persons_with_special_needs)
      FactoryBot.create(:student, admission_no:  '16014/2016', referred_by: :singapore_school_for_the_deaf)

      report = Report.new(@template.merge!(referred_by: ['', 'association_of_persons_with_special_needs']))

      result = report.search_students
      expect(result.count).to eq 1
      expect(result.first.admission_no).to eq '16013/2016'
    end

    it 'returns a combination of search query' do
      FactoryBot.create(:student, admission_no:  '16013/2016', date_of_birth: DateTime.now - 13.years, gender: 'male')
      FactoryBot.create(:student, admission_no:  '16014/2016', date_of_birth: DateTime.now - 13.years, gender: 'female')
      FactoryBot.create(:student, admission_no:  '16015/2016', date_of_birth: DateTime.now - 14.years, gender: 'female')

      report = Report.new(@template.merge!(age: ['', '13'], gender: ['', 'Female']))

      result = report.search_students
      expect(result.count).to eq 1
      expect(result.first.admission_no).to eq '16014/2016'
    end
  end
end
