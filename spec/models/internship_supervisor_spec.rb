require 'rails_helper'

RSpec.describe InternshipSupervisor, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:internship_records) }
    it { is_expected.to belong_to(:internship_company) }
  end
end
