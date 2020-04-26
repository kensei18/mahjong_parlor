require 'rails_helper'

RSpec.describe Parlor, type: :model do
  it 'has a valid factory' do
    expect(build(:parlor)).to be_valid
  end

  describe 'validation for presence' do
    context 'without name' do
      it 'is invalid' do
        expect(build(:parlor, name: '')).not_to be_valid
      end
    end

    context 'without address' do
      it 'is invalid' do
        expect(build(:parlor, address: '')).not_to be_valid
      end
    end

    context 'without latitude' do
      it 'is invalid' do
        expect(build(:parlor, latitude: nil)).not_to be_valid
      end
    end

    context 'without longitude' do
      it 'is invalid' do
        expect(build(:parlor, longitude: nil)).not_to be_valid
      end
    end
  end

  describe 'validation for uniqueness' do
    let!(:parlor) { create(:parlor, :shibuton) }

    context 'when building a parlor with the existing parlor' do
      it 'is invalid' do
        same_parlor = build(:parlor, :shibuton)
        expect(same_parlor).not_to be_valid
      end
    end

    context 'when building a parlor with just the same name as the existing parlor' do
      it 'is valid' do
        other_parlor = build(:parlor, address: '東京都渋谷区道玄坂１丁目１１')
        expect(other_parlor).to be_valid
      end
    end

    context 'when building a parlor with just the same address as the existing parlor' do
      it 'is valid' do
        other_parlor = build(:parlor, name: '雀荘 すずめ荘')
        expect(other_parlor).to be_valid
      end
    end
  end

  describe "validation for website" do
    context "when building a parlor with a valid url" do
      it "is valid" do
        expect(build(:parlor, website: "https://www.mj-octagon.jp/")).to be_valid
      end
    end

    context "when building a parlor with an invalid url" do
      it "is invalid" do
        expect(build(:parlor, website: "www.mj-octagon.jp/")).not_to be_valid
        expect(build(:parlor, website: "https/www.mj-octagon.jp/")).not_to be_valid
        expect(build(:parlor, website: "htt://www.mj-octagon.jp/")).not_to be_valid
        expect(build(:parlor, website: "https://")).not_to be_valid
      end
    end

    context "when building a parlor with blank website" do
      it "is valid" do
        expect(build(:parlor, website: "")).to be_valid
      end
    end

    context "when building a parlor with nil website" do
      it "is valid" do
        expect(build(:parlor, website: nil)).to be_valid
      end
    end
  end

  describe "#search" do
    let!(:parlor_1) { create(:parlor, name: "しぶとん", address: "渋谷") }
    let!(:parlor_2) { create(:parlor, name: "しぶとん", address: "秋葉原") }
    let!(:parlor_3) { create(:parlor, name: "しぶとん", address: "池袋") }
    let!(:parlor_4) { create(:parlor, name: "オクタゴン", address: "渋谷") }
    let!(:parlor_5) { create(:parlor, name: "オクタゴン", address: "秋葉原") }
    let!(:parlor_6) { create(:parlor, name: "オクタゴン", address: "池袋") }

    context "with keywords='しぶとん'" do
      context "without max_num" do
        it "returns parlor_1, parlor_2 and parlor_3" do
          expect(Parlor.search("しぶとん")).to contain_exactly(parlor_1, parlor_2, parlor_3)
        end
      end

      context "with max_num=2" do
        it "returns 2 parlors" do
          expect(Parlor.search("しぶとん", max_num: 2).count).to eq 2
        end
      end
    end

    context "with keywords='秋葉'" do
      it "returns parlor_2 and parlor_5" do
        expect(Parlor.search("秋葉")).to contain_exactly(parlor_2, parlor_5)
      end
    end

    context "with keywords='しぶとん 渋谷'" do
      it "returns parlor_2" do
        expect(Parlor.search("しぶとん 渋谷")).to contain_exactly(parlor_1)
      end
    end

    context "without keyword" do
      it "returns nil" do
        expect(Parlor.search('')).to eq nil
      end
    end
  end

  describe "#display_images" do
    let(:parlor) { create(:parlor) }
    let!(:reviews_with_images) { create_list(:review, 3, :images_attached, parlor: parlor) }
    let!(:reviews_without_images) { create_list(:review, 3, parlor: parlor) }

    context "without count parameter" do
      it "returns array including 3 images" do
        expect(parlor.display_images.length).to eq 3
      end
    end

    context "with count parameter 2" do
      it "returns array including 2 images" do
        expect(parlor.display_images(count: 2).length).to eq 2
      end
    end
  end

  describe "#format_address" do
    context "with Japan" do
      let(:parlor) { create(:parlor, address: "日本、〒150-0043 東京都渋谷区道玄坂２丁目１０−１２") }

      it 'removes Japan from address' do
        expect(parlor.reload.address).to eq "〒150-0043 東京都渋谷区道玄坂２丁目１０−１２"
      end
    end

    context "with Japan" do
      let(:parlor) { create(:parlor, address: "〒150-0043 東京都渋谷区道玄坂２丁目１０−１２") }

      it 'removes Japan from address' do
        expect(parlor.reload.address).to eq "〒150-0043 東京都渋谷区道玄坂２丁目１０−１２"
      end
    end
  end

  describe "#downcase_website" do
    let(:parlor) { create(:parlor, website: "HTTPS://wWw.Mj-octaGON.jP/") }

    it "downcases website url" do
      expect(parlor.website).to eq "https://www.mj-octagon.jp/"
    end
  end

  describe "#rating" do
    let(:parlor) { create(:parlor) }
    let!(:review_1) { create(:review, parlor: parlor, overall: 1, customer: 1) }
    let!(:review_2) { create(:review, parlor: parlor, overall: 2, customer: 1) }
    let!(:review_3) { create(:review, parlor: parlor, overall: 3, customer: 2) }

    context "without parameter" do
      it 'returns reviews overalls average' do
        expect(parlor.rating).to eq 2.0
      end
    end

    context "when the parameter is customer" do
      it 'returns reviews overalls average' do
        expect(parlor.rating(hash: :customer)).to eq 1.3
      end
    end
  end
end
