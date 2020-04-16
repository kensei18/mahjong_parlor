require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "POST /parlors/:parlor_id/reviews" do
    let(:user) { create(:user) }
    let(:parlor) { create(:parlor) }

    context "as user logged in" do
      subject { post parlor_reviews_path(parlor), params: params }

      before do |example|
        sign_in user
        post(parlor_reviews_path(parlor), params: params) unless example.metadata[:skip_before]
      end

      context "when posting a valid review" do
        let(:params) do
          {
            review: {
              title: "良い",
              content: "良いお店でした。",
              overall: 5,
              cleanliness: 5,
              service: 5,
              customer: 5,
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
              overall: nil,
              cleanliness: nil,
              service: nil,
              customer: nil,
            },
          }
        end

        it 'does not create a new review', :skip_before do
          expect { subject }.to change(Review, :count).by(0)
        end

        it 'renders new' do
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

  describe "GET /reviews/:id/edit" do
    let(:review) { create(:review, user: reviewer) }
    let(:reviewer) { create(:user) }

    context "as the same user as the reviewer" do
      before do
        sign_in reviewer
        get edit_review_path(review)
      end

      it "renders edit view" do
        expect(response).to render_template :edit
      end

      it "does not have a flash message" do
        expect(flash[:danger]).to be_nil
      end
    end

    context "as a user different from the reviewer" do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
        get edit_review_path(review)
      end

      it "redirects to root url" do
        expect(response).to redirect_to root_url
      end

      it "has a flash message" do
        expect(flash[:danger]).to eq "ほかのユーザーのレビューは編集できません"
      end
    end
  end

  describe "PATCH /reviews/:id" do
    let(:review) { create(:review, user: reviewer) }
    let(:reviewer) { create(:user) }

    context "as the same user as the reviewer" do
      before do
        sign_in reviewer
        patch review_path review, params: params
      end

      context "when posting a valid review" do
        let(:params) do
          {
            review: {
              title: "悪い",
              content: "ダメダメ",
              overall: 1,
              cleanliness: 1,
              service: 1,
              customer: 1,
            },
          }
        end

        it "updates the review" do
          review.reload
          expect(review.title).to eq "悪い"
          expect(review.content).to eq "ダメダメ"
          expect(review.overall).to eq 1
          expect(review.cleanliness).to eq 1
          expect(review.service).to eq 1
          expect(review.customer).to eq 1
        end

        it "redirects to parlor_url" do
          expect(response).to redirect_to parlor_url(review.parlor)
        end

        it "has a flash message" do
          expect(flash[:success]).to eq "レビューを編集しました！"
        end
      end

      context "when posting a invalid review" do
        let(:params) do
          {
            review: {
              title: "",
              content: "",
              overall: nil,
              cleanliness: nil,
              service: nil,
              customer: nil,
            },
          }
        end

        it "does not update the review" do
          review.reload
          expect(review.title).to eq "良い"
          expect(review.content).to eq "良いお店でした"
          expect(review.overall).to eq 5
          expect(review.cleanliness).to eq 5
          expect(review.service).to eq 5
          expect(review.customer).to eq 5
        end

        it "render edit" do
          expect(response).to render_template :edit
        end
      end
    end

    context "as a user different from the reviewer" do
      let(:other_user) { create(:user) }
      let(:params) do
        {
          review: {
            title: "悪い",
            content: "ダメダメ",
            overall: 1,
            cleanliness: 1,
            service: 1,
            customer: 1,
          },
        }
      end

      before do
        sign_in other_user
        patch review_path review, params: params
      end

      it "does not update the review" do
        review.reload
        expect(review.title).to eq "良い"
        expect(review.content).to eq "良いお店でした"
        expect(review.overall).to eq 5
        expect(review.cleanliness).to eq 5
        expect(review.service).to eq 5
        expect(review.customer).to eq 5
      end

      it "redirects to root url" do
        expect(response).to redirect_to root_url
      end

      it "has a flash message" do
        expect(flash[:danger]).to eq "ほかのユーザーのレビューは編集できません"
      end
    end
  end

  describe "DELETE /reviews/:id" do
    subject { delete review_path(review) }

    let!(:review) { create(:review, user: reviewer) }
    let(:reviewer) { create(:user) }
    let(:parlor) { review.parlor }

    context "as the same user as a reviewer" do
      before do |example|
        sign_in reviewer
        delete review_path(review) unless example.metadata[:skip_before]
      end

      it "deletes the review", :skip_before do
        expect { subject }.to change(Review, :count).by(-1)
      end

      it "redirects to parlor url" do
        expect(response).to redirect_to parlor_url(parlor)
      end

      it "has a warning flash messsage" do
        expect(flash[:warning]).to eq "レビューを削除しました"
      end
    end

    context "as the user different from a reviewer" do
      let(:other_user) { create(:user) }

      before do |example|
        sign_in other_user
        delete review_path(review) unless example.metadata[:skip_before]
      end

      it "deletes the review", :skip_before do
        expect { subject }.to change(Review, :count).by(0)
      end

      it "redirects to parlor url" do
        expect(response).to redirect_to root_url
      end

      it "has a danger flash messsage" do
        expect(flash[:danger]).to eq "ほかのユーザーのレビューは編集できません"
      end
    end
  end
end
