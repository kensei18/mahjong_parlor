require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it 'has a valid factory' do
    expect(build_stubbed(:relationship)).to be_valid
  end

  describe 'validation' do
    context 'without followed_id' do
      it 'is invalid' do
        relationship = build_stubbed(:relationship, followed_id: nil)
        expect(relationship).not_to be_valid
      end
    end

    context 'without follower_id' do
      it 'is invalid' do
        relationship = build_stubbed(:relationship, follower_id: nil)
        expect(relationship).not_to be_valid
      end
    end

    context 'when building an existing relationship again' do
      let!(:relationship) { create(:relationship, follower: follower, followed: followed) }
      let(:follower) { create(:user) }
      let(:followed) { create(:user) }

      it "is invalid" do
        expect(build(:relationship, follower: follower, followed: followed)).not_to be_valid
      end
    end
  end
end
