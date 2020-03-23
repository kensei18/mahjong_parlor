require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'username validation' do
    context 'without a username' do
      it 'is not valid' do
        expect(build(:user, username: '')).not_to be_valid
      end
    end
  end

  describe 'email validation' do
    context 'without an email' do
      it 'is not valid' do
        expect(build(:user, email: '')).not_to be_valid
      end
    end

    context 'with an invalid email' do
      it 'is not valid' do
        expect(build(:user, email: 'user@example')).not_to be_valid
        expect(build(:user, email: '@example.com')).not_to be_valid
        expect(build(:user, email: 'user.example')).not_to be_valid
        expect(build(:user, email: 'user@')).not_to be_valid
      end
    end
  end
end
