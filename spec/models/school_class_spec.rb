require 'rails_helper'

RSpec.describe SchoolClass, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:student_classes) }
    it { is_expected.to have_many(:students).through(:student_classes) }
  end
end
