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
    let!(:parlor) { create(:parlor) }

    context 'when building a parlor with the existing parlor' do
      it 'is invalid' do
        same_parlor = build(:parlor)
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
end
