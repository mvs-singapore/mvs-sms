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
        expect{ user.role = 'some_clown' }.to raise_error(ArgumentError)
      end
    end

    context 'valid' do
      describe 'valid roles' do
        User.roles.keys.each do |role|
          it "valid for #{role}" do
            user.role = role
            expect(user).to be_valid
          end
        end
      end
    end
  end

  describe '.generate_random_password' do
    it 'creates a random password' do
      password = User.generate_random_password

      expect(password).to_not be_nil
      expect(password.size).to eq(10)
    end
  end
end
