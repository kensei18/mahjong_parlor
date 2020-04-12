require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
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

      it 'returns a 302 response' do
        post user_registration_path, params: params
        expect(response).to have_http_status(302)
      end

      it 'creates a new user' do
        expect { post user_registration_path, params: params }.to change(User, :count).by(1)
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

      before { post user_registration_path, params: params }

      it 'returns a 200 response' do
        expect(response).to have_http_status(200)
      end

      it 'renders sign_up page' do
        expect(response.body).to include "アカウント登録"
      end
    end
  end

  describe "GET /users/:id/delete" do
    let(:current_user) { create(:user) }

    before { sign_in current_user }

    context "as a correct user" do
      before { get delete_user_path(current_user) }

      it 'returns a 200 response' do
        expect(response).to have_http_status(200)
      end
    end

    context "as an incorrect user" do
      let(:other_user) { create(:user) }

      before { get delete_user_path(other_user) }

      it 'returns a 302 response' do
        expect(response).to have_http_status(302)
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
      let(:test_user) { create(:user, :test_user) }

      before do |example|
        sign_in test_user
        unless example.metadata[:skip_before]
          delete user_registration_path
        end
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
end
