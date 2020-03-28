require 'rails_helper'

RSpec.describe Parlor, type: :model do
  it 'has a valid factory' do
    expect(build(:parlor)).to be_valid
  end

  context 'when building a parlor with an existing address' do
    let!(:parlor) { create(:parlor) }

    it 'is invalid' do
      expect(build(:parlor)).not_to be_valid
    end
  end
end
