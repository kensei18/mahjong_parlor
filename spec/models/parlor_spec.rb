require 'rails_helper'

RSpec.describe Parlor, type: :model do
  it 'has a valid factory' do
    expect(build(:parlor)).to be_valid
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
end
