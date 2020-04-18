require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    subject { post user_registration_path, params: params }

    before { |example| subject unless example.metadata[:skip_before] }

    context "with valid params" do
      let(:params) do
        {
          user: {
            username: "ユーザー",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password",
          },
        }
      end

      it 'creates a new user', :skip_before do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'redirects to root url' do
        subject
        expect(response).to redirect_to root_url
      end
    end

    context "without username" do
      let(:params) do
        {
          user: {
            email: "user@example.com",
            password: "password",
            password_confirmation: "password",
          },
        }
      end

      it 'does not create a new user', :skip_before do
        expect { subject }.to change(User, :count).by(0)
      end

      it 'renders sign_up page' do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET /users/:id/delete" do
    let(:current_user) { create(:user) }

    before { sign_in current_user }

    context "as a correct user" do
      before { get delete_user_path(current_user) }

      it 'renders delete' do
        expect(response).to render_template :delete
      end
    end

    context "as an incorrect user" do
      let(:other_user) { create(:user) }

      before { get delete_user_path(other_user) }

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH /users" do
    context "as the test user" do
      let(:test_user) { create(:user, :test_user) }
      let(:params) do
        {
          user:
            {
              username: "User",
              current_password: "password",
            },
        }
      end

      before do
        sign_in test_user
        patch user_registration_path, params: params
      end

      it 'does not change the username' do
        expect(test_user.reload.username).to eq "テストユーザー"
      end

      it 'has a flash message' do
        expect(flash[:warning]).to eq "テストユーザーのアカウント情報は操作できません"
      end

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "DELETE /users" do
    context "as the test user" do
      subject { delete user_registration_path }

      let(:test_user) { create(:user, :test_user) }

      before do |example|
        sign_in test_user
        subject unless example.metadata[:skip_before]
      end

      it 'does not change User count', :skip_before do
        expect { subject }.to change(User, :count).by(0)
      end

      it 'has a flash message' do
        expect(flash[:warning]).to eq "テストユーザーのアカウント情報は操作できません"
      end

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH /users/:id/update_content" do
    subject { patch update_content_user_path(user), params: params }

    let(:user) { create(:user, content: "こんにちは") }
    let(:params) do
      {
        user: { content: "始めました" },
        format: :js,
      }
    end

    before { sign_in user }

    it "updates user content" do
      expect { subject }.to change(user, :content).from("こんにちは").to("始めました")
    end

    it "renders update_content" do
      subject
      expect(response).to render_template :update_content
    end
  end
end
