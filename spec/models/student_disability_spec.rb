require 'rails_helper'

RSpec.describe StudentDisability, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:disability) }
  end
end
