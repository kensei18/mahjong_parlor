require 'rails_helper'

RSpec.describe "Parlors", type: :request do
  describe "GET /parlors" do
    it "returns a 200 response" do
      get parlors_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /parlors/new" do
    it 'returns a 200 response' do
      get new_parlor_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /parlors" do
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

      it 'returns a 302 response' do
        post parlors_path, params: params
        expect(response).to have_http_status(302)
      end

      it 'increase the count of parlors by 1' do
        expect { post parlors_path, params: params }.to change(Parlor, :count).by(1)
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

      it 'returns a 200 response' do
        post parlors_path, params: params
        expect(response).to have_http_status(200)
      end
    end
  end
end
