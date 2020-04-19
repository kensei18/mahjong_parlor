require 'rails_helper'

RSpec.describe "Favorites", type: :system do
  let(:user) { create(:user) }
  let(:parlor) { create(:parlor) }

  it "has a favorite button working well on parlor page", js: true do
    visit parlor_path(parlor)

    within '.parlor-detail' do
      expect(page).not_to have_link "お気に入り登録"
      expect(page).not_to have_link "お気に入り解除"
    end

    sign_in user
    visit parlor_path(parlor)

    within '.parlor-detail' do
      expect(page).to have_link "お気に入り登録"
      expect(page).not_to have_link "お気に入り解除"

      expect { click_on "お気に入り登録" }.to change(Favorite, :count).by(1)

      expect(page).not_to have_link "お気に入り登録"
      expect(page).to have_link "お気に入り解除"

      expect { click_on "お気に入り解除" }.to change(Favorite, :count).by(-1)

      expect(page).to have_link "お気に入り登録"
      expect(page).not_to have_link "お気に入り解除"
    end
  end
end
