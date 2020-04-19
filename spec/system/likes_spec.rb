require 'rails_helper'

RSpec.describe "Likes", type: :system do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:review) { create :review, user: other_user }

  before { create_list :like, 5, review: review }

  it "has like button working well on each review", js: true do
    visit user_path(other_user)

    within('.review-index') do
      expect(page).not_to have_link "いいね！"
      expect(page).not_to have_link "いいね！取消"
      expect(page).not_to have_text "いいね！ 5件"

      click_on "詳しく見る"
    end

    within('.review-modal') do
      expect(page).not_to have_link "いいね！"
      expect(page).not_to have_link "いいね！取消"
      expect(page).not_to have_text "いいね！ 5件"
    end

    sign_in user
    visit user_path(other_user)

    within('.review-index') do
      expect(page).to have_link "いいね！"
      expect(page).not_to have_link "いいね！取消"
      expect(page).to have_text "いいね！ 5件"

      click_on "詳しく見る"
    end

    within('.review-modal') do
      expect(page).to have_link "いいね！"
      expect(page).not_to have_link "いいね！取消"
      expect(page).to have_text "いいね！ 5件"

      click_on "いいね！"

      expect(page).to have_link "いいね！取消"
      expect(page).to have_text "いいね！ 6件"

      click_on "閉じる"
    end

    within('.review-index') do
      expect(page).to have_link "いいね！取消"
      expect(page).to have_text "いいね！ 6件"

      click_on "いいね！取消"

      expect(page).to have_link "いいね！"
      expect(page).not_to have_link "いいね！取消"
      expect(page).to have_text "いいね！ 5件"

      click_on "詳しく見る"
    end

    within('.review-modal') do
      expect(page).to have_link "いいね！"
      expect(page).not_to have_link "いいね！取消"
      expect(page).to have_text "いいね！ 5件"
    end
  end
end
