require 'rails_helper'

RSpec.describe StudentClass, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:school_class) }
  end
end
