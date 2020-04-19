require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "validation" do
    context "without user_id" do
      it "is invalid" do
        expect(build(:favorite, user: nil)).not_to be_valid
      end
    end

    context "without parlor_id" do
      it "is invalid" do
        expect(build(:favorite, parlor: nil)).not_to be_valid
      end
    end

    context "when building an existing favorite again" do
      let!(:favorite) { create(:favorite, user: user, parlor: parlor) }
      let(:user) { create(:user) }
      let(:parlor) { create(:parlor) }

      it "is invalid" do
        expect(build(:favorite, user: user, parlor: parlor)).not_to be_valid
      end
    end
  end
end
