require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid-email').for(:email) }
  end

  describe 'associations' do
    it { should have_many(:contacts).dependent(:destroy) }
  end

  describe 'secure password' do
    it { should have_secure_password }
  end

  describe 'auth token' do
    it 'has an auth token after creation' do
      user = create(:user)
      expect(user.auth_token).not_to be_nil
    end

    describe '#regenerate_auth_token' do
      it 'changes the auth token' do
        user = create(:user)
        original_token = user.auth_token
        user.regenerate_auth_token
        expect(user.auth_token).not_to eq(original_token)
      end
    end
  end
end
