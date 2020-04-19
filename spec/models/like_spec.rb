require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "validation" do
    context "without user" do
      it "is invalid" do
        expect(build(:like, user: nil)).not_to be_valid
      end
    end

    context "without review" do
      it "is invalid" do
        expect(build(:like, review: nil)).not_to be_valid
      end
    end

    context "when building an existing like" do
      let!(:like) { create :like, user: user, review: review }
      let(:user) { create :user }
      let(:review) { create :review }

      it "is invalid" do
        expect(build(:like, user: user, review: review)).not_to be_valid
      end
    end
  end
end
