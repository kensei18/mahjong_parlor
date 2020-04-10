require 'rails_helper'

RSpec.describe "Parlors", type: :system do
  it 'has parlors and new_parlor pages working well' do
    visit root_path

    # /
    expect(title).to eq 'Mahjong Parlor'

    within('.content-wrapper') do
      expect(page).to have_selector 'div#parlors-index-map'
    end

    within('header') do
      expect(page).to have_selector 'a', text: 'Mahjong Parlor'
      expect(page).to have_selector 'a', text: '雀荘登録'
      click_link '雀荘登録'
    end

    # /parlors/new
    expect(title).to eq '雀荘登録 | Mahjong Parlor'

    within('.search-form') do
      expect(page).to have_selector 'input#address'
      expect(page).to have_selector 'button#address-submit'
    end

    expect(page).to have_selector 'div#parlors-new-map'

    within('.registration-form') do
      expect(page).not_to have_selector 'div.error-message'
      expect(page).to have_field '店舗名'
      expect(page).to have_field '住所'
      expect(page).to have_field '緯度'
      expect(page).to have_field '経度'
      expect(page).to have_button '登録'

      click_button '登録'
    end

    expect(title).to eq '雀荘登録 | Mahjong Parlor'

    within('.registration-form') do
      expect(page).to have_selector 'div.error-message'
      within('.error-message') do
        expect(page).to have_selector 'li', count: 4
      end

      fill_in '店舗名', with: 'しぶとん'
      fill_in '住所', with: '東京都渋谷区道玄坂２丁目１０−１２'
      fill_in '緯度', with: 35.6588497
      fill_in '経度', with: 139.6990777
      click_button '登録'
    end

    expect(title).to eq 'Mahjong Parlor'
  end
end
