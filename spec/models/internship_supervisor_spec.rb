require 'rails_helper'

RSpec.describe InternshipSupervisor, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:contact_number) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:internship_records) }
    it { is_expected.to belong_to(:internship_company) }
  end
end
