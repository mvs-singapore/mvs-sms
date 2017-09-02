require 'rails_helper'

RSpec.describe Remark, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:user) }
  end
end
