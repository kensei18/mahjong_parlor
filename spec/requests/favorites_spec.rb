require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  describe "POST /parlors/:id/favorites" do
    subject { post parlor_favorites_path(parlor), params: { format: :js } }

    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }

    before { sign_in user }

    it "creates a new favorite" do
      expect { subject }.to change(Favorite, :count).by(1)
    end

    it "renders create" do
      subject
      expect(response).to render_template :create
    end
  end

  describe "DELETE /favorites/:id" do
    subject { delete favorite_path(favorite), params: { format: :js } }

    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }
    let!(:favorite) { create(:favorite, user: user, parlor: parlor) }

    before { sign_in user }

    it "creates a new favorite" do
      expect { subject }.to change(Favorite, :count).by(-1)
    end

    it "renders create" do
      subject
      expect(response).to render_template :destroy
    end
  end
end
