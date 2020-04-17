require 'rails_helper'

RSpec.describe "Parlors", type: :request do
  describe "POST /parlors" do
    subject { post parlors_path, params: params }

    before do |example|
      subject unless example.metadata[:skip_before]
    end

    context "with valid params" do
      let(:params) do
        {
          parlor:
            {
              name: "しぶとん",
              address: "東京都渋谷区道玄坂２丁目１０−１２",
              latitude: 35.6588497,
              longitude: 139.6990777,
            },
        }
      end

      it 'redirects to root url' do
        expect(response).to redirect_to root_url
      end

      it 'creates a parlor', :skip_before do
        expect { subject }.to change(Parlor, :count).by(1)
      end
    end

    context "with invalid params" do
      let(:params) do
        {
          parlor:
            {
              name: "",
              address: "",
              latitude: nil,
              longitude: nil,
            },
        }
      end

      it 'renders new' do
        expect(response).to render_template :new
      end

      it 'does not create a parlor', :skip_before do
        expect { subject }.to change(Parlor, :count).by(0)
      end
    end
  end

  describe "PATCH /parlors/:id" do
    let(:parlor) { create(:parlor, website: "", smoking: 0) }

    before { patch parlor_path(parlor, params: params) }

    context "with a valid params" do
      let(:params) do
        {
          parlor: {
            website: "http://www.shibuton.jp/",
            smoking: "smoking_allowed",
          },
        }
      end

      it "updates website and smoking" do
        parlor.reload
        expect(parlor.website).to eq "http://www.shibuton.jp/"
        expect(parlor.smoking_allowed?).to be_truthy
      end

      it "redirects to parlor url" do
        expect(response).to redirect_to parlor_url(parlor)
      end

      it "has a success flash message" do
        expect(flash[:success]).to eq "しぶとんの情報を更新しました！"
      end
    end

    context "with an invalid params" do
      let(:params) do
        {
          parlor: {
            website: "ww.shibuton.jp/",
            smoking: "",
          },
        }
      end

      it "does not update website and smoking" do
        parlor.reload
        expect(parlor.website).to eq ""
        expect(parlor.unknown?).to be_truthy
      end

      it "redirects to parlor url" do
        expect(response).to redirect_to parlor_url(parlor)
      end

      it "has a success flash message" do
        expect(flash[:danger]).to eq "入力に不備があり、更新に失敗しました"
      end
    end
  end

  describe "DELETE /parlors/:id" do
    subject { delete parlor_path(parlor) }

    let!(:parlor) { create(:parlor) }

    context "as an admin user" do
      let(:admin_user) { create(:user, admin: true) }

      before do |example|
        sign_in admin_user
        subject unless example.metadata[:skip_before]
      end

      it "destroys the parlor", :skip_before do
        expect { subject }.to change(Parlor, :count).by(-1)
      end

      it "redirects to root url" do
        expect(response).to redirect_to root_url
      end

      it "has a warning flash message" do
        expect(flash[:warning]).to eq "#{parlor.name}を削除しました"
      end
    end

    context "as a user without admin" do
      let(:not_admin_user) { create(:user) }

      before do |example|
        sign_in not_admin_user
        subject unless example.metadata[:skip_before]
      end

      it "destroys the parlor", :skip_before do
        expect { subject }.to change(Parlor, :count).by(0)
      end

      it "redirects to parlor url" do
        expect(response).to redirect_to parlor_url(parlor)
      end
    end

    context "when not logged in" do
      before do |example|
        subject unless example.metadata[:skip_before]
      end

      it "destroys the parlor", :skip_before do
        expect { subject }.to change(Parlor, :count).by(0)
      end

      it "redirects to parlor url" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
