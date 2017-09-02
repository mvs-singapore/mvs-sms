require 'rails_helper'

RSpec.describe StudentStatusHistory, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:student) }
  end
end
