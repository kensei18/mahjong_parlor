require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  before do |example|
    sign_in user
    subject unless example.metadata[:skip_before]
  end

  describe "POST /parlors/:id/favorites" do
    subject { post parlor_favorites_path(parlor), params: { format: :js } }

    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }

    it "creates a new favorite", :skip_before do
      expect { subject }.to change(Favorite, :count).by(1)
    end

    it "adds parlor to user favorites" do
      expect(user).to be_favorite parlor
    end

    it "renders create" do
      expect(response).to render_template :create
    end
  end

  describe "DELETE /favorites/:id" do
    subject { delete favorite_path(favorite), params: { format: :js } }

    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }
    let!(:favorite) { create(:favorite, user: user, parlor: parlor) }

    it "creates a new favorite", :skip_before do
      expect { subject }.to change(Favorite, :count).by(-1)
    end

    it "removes parlor from user favorites" do
      expect(user).not_to be_favorite parlor
    end

    it "renders create" do
      subject
      expect(response).to render_template :destroy
    end
  end
end
