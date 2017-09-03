require 'rails_helper'

RSpec.describe Remark, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:event_date) }
    it { is_expected.to validate_presence_of(:category) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:user) }
  end
end
