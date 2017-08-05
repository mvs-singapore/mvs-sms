require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { User.new(email: "michael@example.com", password: "hello123") }

    context 'invalid' do
      it 'must not be empty' do
        user.role = ''
        expect(user).to_not be_valid
      end

      it 'must have valid role name' do
        user.role = 'some_clown'
        expect(user).to_not be_valid
      end
    end

    context 'valid' do
      describe 'valid roles' do
        User::USER_ROLES.each do |role|
          it "valid for #{role}" do
            user.role = role
            expect(user).to be_valid
          end
        end
      end
    end
  end

  # describe 'hello' do
  #     it 'has valid email' do
  #         user = User.new(email: "michael@example.com", password: "hello123")

  #         expect(user).to be_valid
  #     end
  # end
end
