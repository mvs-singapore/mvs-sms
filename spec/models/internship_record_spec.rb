require 'rails_helper'

RSpec.describe InternshipRecord, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:from_date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:internship_company) }
    it { is_expected.to belong_to(:internship_supervisor) }
  end
end
