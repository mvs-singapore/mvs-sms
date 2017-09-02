require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:teacher_role) { Role.create(name: 'teacher') }
    let(:user) { User.new(email: "michael@example.com", password: "hello123", role: teacher_role, name: "Awesome Guy") }

    context 'invalid' do
      it 'must have name' do
        user.name = ''
        expect(user).to_not be_valid
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:remarks) }
  end

  describe '.generate_random_password' do
    it 'creates a random password' do
      password = User.generate_random_password

      expect(password).to_not be_nil
      expect(password.size).to eq(10)
    end
  end
end
