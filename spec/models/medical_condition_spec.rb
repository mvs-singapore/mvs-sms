require 'rails_helper'

RSpec.describe MedicalCondition, type: :model do
  describe 'validation' do
    it{ is_expected.to validate_presence_of(:title) }
  end

end
