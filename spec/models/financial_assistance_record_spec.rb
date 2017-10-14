require 'rails_helper'

RSpec.describe FinancialAssistanceRecord, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end
end
