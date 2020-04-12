require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "POST /parlors/:parlor_id/reviews" do
    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }

    context "as user logged in" do
      subject { post parlor_reviews_path(parlor), params: params }

      before do |example|
        sign_in user
        unless example.metadata[:skip_before]
          post(parlor_reviews_path(parlor), params: params)
        end
      end

      context "when posting a valid review" do
        let(:params) do
          {
            review: {
              title: "良い",
              content: "良いお店でした。",
              overall: 5,
              cleanliness: 4,
              service: 3,
              customer: 2,
            },
          }
        end

        it 'creates a new review', :skip_before do
          expect { subject }.to change(Review, :count).by(1)
        end

        it 'redirects to parlor url' do
          expect(response).to redirect_to parlor_path(parlor)
        end

        it 'has a flash message' do
          expect(flash[:success]).to eq "新しいレビューを投稿しました！"
        end
      end

      context "when posting a invalid review" do
        let(:params) do
          {
            review: {
              title: "",
              content: "",
              overall: 5,
              cleanliness: 4,
              service: 3,
              customer: 2,
            },
          }
        end

        it 'does not create a new review', :skip_before do
          expect { subject }.to change(Review, :count).by(0)
        end

        it 'renders new', :skip_before do
          expect(response).to render_template :new
        end
      end
    end

    context "as user not logged in" do
      it 'redirects to login url' do
        post parlor_reviews_path(parlor)
        expect(response).to redirect_to new_user_session_url
      end
    end
  end
end
