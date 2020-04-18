require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:review) { create(:review, user: other_user) }
  let!(:comments) { create_list(:comment, 3, review: review) }

  it "has comments view and a comment form in review modal working well", js: true do
    visit user_path(other_user)

    expect(page).to have_selector '.review-index', count: 1

    within '.review-index' do
      click_on "詳しく見る"
    end

    expect(page).to have_selector '.review-modal', count: 1

    within "#review-modal-#{review.id}" do
      expect(page).to have_selector '.comments-index', count: 3
      expect(page).not_to have_selector 'textarea#comment_content'
      expect(page).not_to have_button "コメントする"
    end

    sign_in user
    visit user_path(other_user)

    within '.review-index' do
      click_on "詳しく見る"
    end

    within "#review-modal-#{review.id}" do
      expect(page).to have_selector '.comments-index', count: 3
      expect(page).not_to have_link "削除"
      expect(page).to have_selector 'textarea#comment_content'
      expect(page).to have_button "コメントする"

      click_on "コメントする"

      expect(page).to have_selector '.comments-index', count: 3
      expect(page).not_to have_link "削除"
      expect(page).to have_selector 'textarea#comment_content'
      expect(page).to have_button "コメントする"

      find('textarea#comment_content').fill_in with: "なるほど"
      click_on "コメントする"

      expect(page).to have_selector '.comments-index', count: 4
      expect(page).to have_link "削除", count: 1
      expect(page).to have_selector 'textarea#comment_content'
      expect(page).to have_button "コメントする"

      within(all('.comments-index')[3]) do
        expect(page).to have_link "削除"
        expect(page).to have_text "なるほど"

        click_on "削除"
      end

      expect(page).to have_selector '.comments-index', count: 3
      expect(page).not_to have_text "なるほど"
      expect(page).to have_selector 'textarea#comment_content'
      expect(page).to have_button "コメントする"
    end
  end
end
