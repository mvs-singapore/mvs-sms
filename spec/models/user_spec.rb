require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'hello' do
      it 'has valid email' do
          user = User.new(email: "michael@example.com", password: "hello123")

          expect(user).to be_valid
      end
  end
end
