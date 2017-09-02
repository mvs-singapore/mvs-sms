require 'rails_helper'

RSpec.describe StudentMedicalCondition, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end
end
