require 'rails_helper'

RSpec.describe "Parlors", type: :system do
  describe "Create a parlor" do
    it 'has parlors and new_parlor pages working well' do
      visit root_path

      expect(current_path).to eq root_path
      expect(title).to eq 'Mahjong Parlor'

      within('.content-wrapper') do
        expect(page).to have_selector 'div#parlors-index-map'
      end

      within('header') do
        expect(page).to have_selector 'a', text: 'Mahjong Parlor'
        expect(page).to have_selector 'a', text: '雀荘登録'
        click_link '雀荘登録'
      end

      expect(current_path).to eq new_parlor_path
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

        expect { click_button '登録' }.to change(Parlor, :count).by(0)
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
        expect { click_button '登録' }.to change(Parlor, :count).by(1)
      end

      expect(current_path).to eq root_path
    end
  end

  describe "Edit a parlor" do
    let(:parlor) { create(:parlor, website: "", smoking: 'no_smoking') }

    it 'has show-parlor page and edit-parlor modal in each parlor page' do
      visit parlor_path(parlor)

      expect(title).to eq "#{parlor.name} | Mahjong Parlor"

      within('.parlor-detail') do
        expect(page).to have_text parlor.name
        expect(page).to have_text parlor.address
        expect(page).to have_text "（登録されていません）"
        expect(page).to have_text "禁煙"
        expect(page).to have_selector 'div#parlors-show-map'
      end

      within('#edit-parlor') do
        expect(page).to have_select("タバコ", selected: "禁煙", options: %w(不明 禁煙 喫煙 分煙))

        fill_in "URL", with: "ww.com"
        select "喫煙", from: "タバコ"

        click_on "更新"
      end

      parlor.reload
      expect(current_path).to eq parlor_path(parlor)
      expect(page).to have_text "入力に不備があり、更新に失敗しました"

      within('.parlor-detail') do
        expect(page).to have_text parlor.name
        expect(page).to have_text parlor.address
        expect(page).to have_text "（登録されていません）"
        expect(page).to have_text "禁煙"
      end

      within('#edit-parlor') do
        fill_in "URL", with: "http://www.shibuton.jp/"
        select "喫煙", from: "タバコ"

        click_on "更新"
      end

      parlor.reload
      expect(current_path).to eq parlor_path(parlor)
      expect(page).to have_text "#{parlor.name}の情報を更新しました！"

      within('.parlor-detail') do
        expect(page).to have_text parlor.name
        expect(page).to have_text parlor.address
        expect(page).to have_text "http://www.shibuton.jp/"
        expect(page).to have_text "喫煙"
      end
    end
  end
end
