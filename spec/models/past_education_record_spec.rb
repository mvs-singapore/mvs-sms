require 'rails_helper'

RSpec.describe PastEducationRecord, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:school_name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end
end
