require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'validation' do
    context 'without username' do
      it 'is not valid' do
        expect(build(:user, username: '')).not_to be_valid
      end
    end
  end
end
