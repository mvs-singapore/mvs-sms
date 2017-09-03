require 'rails_helper'

RSpec.describe StudentStatusHistory, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end
end
