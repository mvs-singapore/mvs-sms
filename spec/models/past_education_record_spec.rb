require 'rails_helper'

RSpec.describe PastEducationRecord, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:school_name) }
    it { is_expected.to validate_presence_of(:from_date) }
    it { is_expected.to validate_presence_of(:to_date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end
end
