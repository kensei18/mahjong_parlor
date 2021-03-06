require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  describe "Post new review and edit the review" do
    let!(:test_user) { create(:user, :test_user) }
    let(:parlor) { create(:parlor) }
    let(:other_user) { create(:user) }
    let!(:review) { create(:review, parlor: parlor, user: other_user, created_at: 1.days.ago) }

    it "has review pages working well" do
      visit parlor_path(parlor)

      expect(page).to have_selector 'div.review-index', count: 1

      within('.parlor-images') do
        expect(page).to have_selector 'img', count: 0
        expect(page).to have_text "写真は投稿されていません"
      end

      within('.review-index') do
        expect(page).to have_text "#{other_user.username}さんのレビュー"
        expect(page).to have_link other_user.username, href: user_path(other_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 5
        expect(page).to have_selector '.review-unstar', count: 0
        expect(page).to have_text review.title
        expect(page).to have_text review.content
        expect(page).not_to have_link "レビュー編集"
        expect(page).not_to have_link "レビュー削除"
      end

      within('.review-modal') do
        expect(page).to have_text "#{other_user.username}さんのレビュー"
        expect(page).to have_link other_user.username, href: user_path(other_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 20
        expect(page).to have_selector '.review-unstar', count: 0
        expect(page).to have_text review.title
        expect(page).to have_text review.content
        expect(page).to have_selector 'img', count: 0
        expect(page).not_to have_link "レビュー編集"
        expect(page).not_to have_link "レビュー削除"
      end

      within('.parlor-detail') do
        click_on "レビューを投稿する！"
      end

      expect(current_path).to eq new_user_session_path
      click_on "テストユーザー"

      expect(current_path).to eq new_parlor_review_path(parlor)
      expect(title).to eq "レビュー投稿 | Mahjong Parlor"

      within('.review-form') do
        fill_in "タイトル", with: ""
        fill_in "詳細", with: ""

        expect { click_on "投稿！" }.to change(Review, :count).by(0)
      end

      expect(title).to eq "レビュー投稿 | Mahjong Parlor"

      within('.review-form') do
        expect(page).to have_selector 'div.error-message'

        fill_in "タイトル", with: "まあまあ"
        fill_in "詳細", with: "そこそこです"

        expect { click_on "投稿！" }.to change(Review, :count).by(0)
      end

      expect(title).to eq "レビュー投稿 | Mahjong Parlor"

      within('.review-form') do
        expect(page).to have_selector 'div.error-message'

        expect(page).to have_field "タイトル", with: "まあまあ"
        expect(page).to have_field "詳細", with: "そこそこです"

        within('#overall-radio') do
          find("#review_overall_4").choose
        end

        within('#cleanliness-radio') do
          find("#review_cleanliness_4").choose
        end

        within('#service-radio') do
          find("#review_service_4").choose
        end

        within('#customer-radio') do
          find("#review_customer_4").choose
        end

        attach_file "店舗の写真", "#{Rails.root}/spec/factories/images/test.png"

        expect { click_on "投稿！" }.to change(Review, :count).by(1)
      end

      expect(current_path).to eq parlor_path(parlor)
      expect(page).to have_selector '.alert-success', text: "新しいレビューを投稿しました！"
      expect(page).to have_selector 'div.review-index', count: 2

      within('.parlor-images') do
        expect(page).to have_selector 'img', count: 1
        expect(page).not_to have_text "写真は投稿されていません"
      end

      within all('.review-index')[0] do
        expect(page).to have_text "テストユーザーさんのレビュー"
        expect(page).to have_link "テストユーザー", href: user_path(test_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 4
        expect(page).to have_selector '.review-unstar', count: 1
        expect(page).to have_text "まあまあ"
        expect(page).to have_text "そこそこです"
        expect(page).to have_link "レビュー編集"
        expect(page).to have_link "レビュー削除"
      end

      within all('.review-modal')[0] do
        expect(page).to have_text "テストユーザーさんのレビュー"
        expect(page).to have_link "テストユーザー", href: user_path(test_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 16
        expect(page).to have_selector '.review-unstar', count: 4
        expect(page).to have_text "まあまあ"
        expect(page).to have_text "そこそこです"
        expect(page).to have_selector 'img', count: 1
        expect(page).to have_link "レビュー編集"
        expect(page).to have_link "レビュー削除"
      end

      within all('.review-index')[1] do
        expect(page).to have_text "#{other_user.username}さんのレビュー"
        expect(page).to have_link other_user.username, href: user_path(other_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 5
        expect(page).to have_selector '.review-unstar', count: 0
        expect(page).to have_text review.title
        expect(page).to have_text review.content
        expect(page).not_to have_link "レビュー編集"
        expect(page).not_to have_link "レビュー削除"
      end

      within all('.review-modal')[1] do
        expect(page).to have_text "#{other_user.username}さんのレビュー"
        expect(page).to have_link other_user.username, href: user_path(other_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 20
        expect(page).to have_selector '.review-unstar', count: 0
        expect(page).to have_text review.title
        expect(page).to have_text review.content
        expect(page).to have_selector 'img', count: 0
        expect(page).not_to have_link "レビュー編集"
        expect(page).not_to have_link "レビュー削除"
      end

      within('.parlor-detail') do
        click_on "レビューを投稿する！"
      end

      expect(current_path).to eq new_parlor_review_path(parlor)
      click_on "お店のページへ戻る"

      expect(current_path).to eq parlor_path(parlor)

      within all('.review-index')[0] do
        click_on "レビュー編集"
      end

      expect(current_path).to eq edit_review_path(test_user.reviews.first)
      expect(title).to eq "レビュー編集 | Mahjong Parlor"
      click_on "お店のページへ戻る"

      expect(current_path).to eq parlor_path(parlor)

      within all('.review-index')[0] do
        click_on "レビュー編集"
      end

      expect(current_path).to eq edit_review_path(test_user.reviews.first)

      within('.review-form') do
        expect(page).to have_field "タイトル", with: "まあまあ"
        expect(page).to have_field "詳細", with: "そこそこです"
        expect(page).to have_unchecked_field "投稿した写真を削除する"
        expect(page).to have_link "レビュー削除", href: review_path(test_user.reviews.first)

        fill_in "タイトル", with: ""
        fill_in "詳細", with: ""
        click_on "保存"
      end

      expect(title).to eq "レビュー編集 | Mahjong Parlor"

      within('.review-form') do
        expect(page).to have_selector '.error-message'

        fill_in "タイトル", with: "最悪"
        fill_in "詳細", with: "ダメダメ"

        within('#overall-radio') do
          find("#review_overall_1").choose
        end

        within('#cleanliness-radio') do
          find("#review_cleanliness_1").choose
        end

        within('#service-radio') do
          find("#review_service_1").choose
        end

        within('#customer-radio') do
          find("#review_customer_1").choose
        end

        check "投稿した写真を削除する"

        click_on "保存"
      end

      expect(current_path).to eq parlor_path(parlor)
      expect(page).to have_selector '.alert-success', text: "レビューを編集しました！"
      expect(page).to have_selector 'div.review-index', count: 2

      within('.parlor-images') do
        expect(page).to have_selector 'img', count: 0
        expect(page).to have_text "写真は投稿されていません"
      end

      within all('.review-index')[0] do
        expect(page).to have_text "テストユーザーさんのレビュー"
        expect(page).to have_link "テストユーザー", href: user_path(test_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 1
        expect(page).to have_selector '.review-unstar', count: 4
        expect(page).to have_text "最悪"
        expect(page).to have_text "ダメダメ"
        expect(page).to have_link "レビュー編集"
        expect(page).to have_link "レビュー削除", href: review_path(test_user.reviews.first)
      end

      within all('.review-modal')[0] do
        expect(page).to have_text "テストユーザーさんのレビュー"
        expect(page).to have_link "テストユーザー", href: user_path(test_user)
        expect(page).to have_link parlor.name, href: parlor_path(parlor)
        expect(page).to have_selector '.review-star', count: 4
        expect(page).to have_selector '.review-unstar', count: 16
        expect(page).to have_text "最悪"
        expect(page).to have_text "ダメダメ"
        expect(page).to have_selector 'img', count: 0
        expect(page).to have_link "レビュー編集"
        expect(page).to have_link "レビュー削除"

        expect { click_on "レビュー削除" }.to change(Review, :count).by(-1)
      end

      expect(current_path).to eq parlor_path(parlor)
      expect(page).to have_selector '.alert-warning', text: "レビューを削除しました"

      expect(page).to have_selector 'div.review-index', count: 1
      expect(page).not_to have_link "レビュー編集"
      expect(page).not_to have_link "レビュー削除"
    end
  end
end
