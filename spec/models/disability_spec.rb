require 'rails_helper'

RSpec.describe Disability, type: :model do
  describe 'validation' do
    it{ is_expected.to validate_presence_of(:title) }
  end
end
