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
end
