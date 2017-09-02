require 'rails_helper'

RSpec.describe InternshipCompany, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:internship_records) }
  end
end
