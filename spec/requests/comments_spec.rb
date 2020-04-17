require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "POST /reviews/:id/comments" do
    subject { post review_comments_path(review), params: params }

    let(:review) { create(:review) }
    let(:user) { create(:user) }

    before do |example|
      sign_in user
      subject unless example.metadata[:skip_before]
    end

    context "with valid params" do
      let(:params) do
        {
          comment: { content: "参考になった" },
          format: :js,
        }
      end

      it "creates a new comment", :skip_before do
        expect { subject }.to change(Comment, :count).by(1)
      end

      it "renders create" do
        expect(response).to render_template :create
      end
    end

    context "with invalid params" do
      let(:params) do
        {
          comment: {
            content: "",
          },
          format: 'js',
        }
      end

      it "creates a new comment", :skip_before do
        expect { subject }.to change(Comment, :count).by(0)
      end

      it "renders create" do
        expect(response).to render_template :create
      end
    end
  end

  describe "DELETE /comments/:id" do
    subject { delete comment_path(comment), params: { format: :js } }

    let!(:comment) { create(:comment, user: user) }
    let(:user) { create(:user) }

    context "as a correct user" do
      before do
        sign_in user
      end

      it "destroys the comment" do
        expect { subject }.to change(Comment, :count).by(-1)
      end

      it "renders destroy" do
        subject
        expect(response).to render_template :destroy
      end
    end

    context "as a incorrect user" do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it "destroys the comment" do
        expect { subject }.to change(Comment, :count).by(0)
      end

      it "redirects to parlor url" do
        subject
        expect(response).to redirect_to parlor_url(comment.parlor)
      end
    end
  end
end
