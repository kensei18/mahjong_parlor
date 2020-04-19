require 'rails_helper'

RSpec.describe "Likes", type: :request do
  before do |example|
    sign_in user
    subject unless example.metadata[:skip_before]
  end

  describe "POST /reviews/:id/likes" do
    subject { post review_likes_path(review), params: { format: :js } }

    let(:user) { create :user }
    let(:review) { create :review }

    it "creates a like", :skip_before do
      expect { subject }.to change(Like, :count).by(1)
    end

    it "makes user to like review" do
      expect(user).to be_like review
    end

    it "renders create" do
      expect(response).to render_template :create
    end
  end

  describe "DELETE /likes/:id" do
    subject { delete like_path(like), params: { format: :js } }

    let!(:like) { create :like, user: user, review: review }
    let(:user) { create :user }
    let(:review) { create :review }

    it "destroys a like", :skip_before do
      expect { subject }.to change(Like, :count).by(-1)
    end

    it "makes user to unlike review" do
      expect(user).not_to be_like review
    end

    it "renders create" do
      expect(response).to render_template :destroy
    end
  end
end
