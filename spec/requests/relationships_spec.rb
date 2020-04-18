require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "POST /users/:id/relationships" do
    subject { post user_relationships_path(other_user), params: { format: :js } }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { sign_in user }

    it "creates user's new active relationship" do
      expect { subject }.to change { user.active_relationships.count }.by(1)
    end

    it "creates other_user's new passive relationship" do
      expect { subject }.to change { other_user.passive_relationships.count }.by(1)
    end

    it "renders create" do
      subject
      expect(response).to render_template :create
    end
  end

  describe "DELETE /relationships/:id" do
    subject { delete relationship_path(relationship), params: { format: :js } }

    let!(:relationship) { create(:relationship, follower: user, followed: other_user) }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { sign_in user }

    it "destroys user's active relationship" do
      expect { subject }.to change { user.active_relationships.count }.by(-1)
    end

    it "destroys other_user's passive relationship" do
      expect { subject }.to change { other_user.passive_relationships.count }.by(-1)
    end

    it "renders destroy" do
      subject
      expect(response).to render_template :destroy
    end
  end
end
