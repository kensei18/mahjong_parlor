require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'username validation' do
    context 'without a username' do
      it 'is invalid' do
        expect(build(:user, username: '')).not_to be_valid
      end
    end

    context "when existing a user with the same username" do
      let!(:user) { create(:user, username: "ユーザー") }

      it 'is invalid' do
        expect(build(:user, username: "ユーザー")).not_to be_valid
      end
    end
  end

  describe 'email validation' do
    context 'without an email' do
      it 'is invalid' do
        expect(build(:user, email: '')).not_to be_valid
      end
    end

    context 'with an invalid email' do
      it 'is invalid' do
        expect(build(:user, email: 'user@example')).not_to be_valid
        expect(build(:user, email: '@example.com')).not_to be_valid
        expect(build(:user, email: 'user.example')).not_to be_valid
        expect(build(:user, email: 'user@')).not_to be_valid
      end
    end

    context 'with uppercase email address' do
      it 'is saved after changing upper-case letters to lower-case letters' do
        user = create(:user, email: 'UsEr@ExaMPLE.CoM')
        expect(user.email).to eq 'user@example.com'
      end
    end
  end

  describe 'relationships' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context 'with a relationship that the follower is user1 and the followed user is user2' do
      let!(:relationship) { create(:relationship, follower: user1, followed: user2) }

      it 'following of user1 include user2' do
        expect(user1.following).to include user2
      end

      it 'followers of user2 include user1' do
        expect(user2.followers).to include user1
      end

      it 'returns that user1 is following user2' do
        expect(user1).to be_following user2
      end

      it 'returns that user2 is not following user1' do
        expect(user2).not_to be_following user1
      end

      describe '#unfollow' do
        it 'destroy the relationship that user1 is following user2' do
          user1.unfollow user2
          expect(user1).not_to be_following user2
        end
      end
    end

    describe '#follow' do
      it 'create a relationship that user1 is following user2' do
        user1.follow user2
        expect(user1).to be_following user2
      end
    end
  end

  describe 'favorites' do
    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }

    context "when user favors parlor" do
      let!(:favorite) { create(:favorite, user: user, parlor: parlor) }

      it "of user include parlor" do
        expect(user.favorite_parlors).to include parlor
      end

      describe "#favorite?" do
        it "returns true" do
          expect(user).to be_favorite parlor
        end
      end

      describe "#remove_from_favorites" do
        it "destroys a favorite" do
          user.remove_from_favorites parlor
          expect(user).not_to be_favorite parlor
        end
      end
    end

    describe "#add_to_favorites" do
      it "creates a favorite" do
        user.add_to_favorites parlor
        expect(user).to be_favorite parlor
      end
    end
  end

  describe "like" do
    let(:user) { create(:user) }
    let(:review) { create(:review) }

    context "when user likes review" do
      let!(:like) { create(:like, user: user, review: review) }

      it "of user include review" do
        expect(user.like_reviews).to include review
      end

      describe "#like?" do
        it "returns true" do
          expect(user).to be_like review
        end
      end

      describe "#unlike" do
        it "destroy a like" do
          user.unlike review
          expect(user).not_to be_like review
        end
      end
    end

    describe "#like" do
      it "creates a like" do
        user.like review
        expect(user).to be_like review
      end
    end
  end
end
