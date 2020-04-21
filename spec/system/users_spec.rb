require 'rails_helper'

def extract_url_from(mail)
  body = mail.body.encoded
  body[/http[^"]+/]
end

RSpec.describe "Users", type: :system do
  context 'without an existing account' do
    describe 'Sign Up' do
      it 'has a sign up page working well' do
        visit root_path

        # Test for Sign Up
        within('header') do
          expect(page).to have_selector 'a', text: "アカウント登録"
          expect(page).to have_selector 'a', text: "ログイン"
          expect(page).not_to have_selector 'a', text: "アカウント情報"
          expect(page).not_to have_selector 'a', text: "ログアウト"

          click_link "アカウント登録"
        end

        expect(current_path).to eq new_user_registration_path
        expect(title).to eq "アカウント登録 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector 'h2', text: "アカウント登録"
          expect(page).to have_field "ユーザー名"
          expect(page).to have_field "メールアドレス"
          expect(page).to have_field "パスワード"
          expect(page).to have_field "確認用パスワード"
          expect(page).to have_button "アカウント登録"

          fill_in "ユーザー名", with: ""
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: ""
          fill_in "確認用パスワード", with: ""
          expect { click_button "アカウント登録" }.to change(User, :count).by(0)
        end

        expect(title).to eq "アカウント登録 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector '.error-message'

          fill_in "ユーザー名", with: "ユーザー"
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          fill_in "確認用パスワード", with: "password"
          expect { click_button "アカウント登録" }.to change(User, :count).by(1)
        end

        expect(current_path).to eq root_path

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('header') do
          expect(page).to have_selector 'a', text: "ユーザー"
          expect(page).to have_selector 'a', text: "アカウント情報"
          expect(page).to have_selector 'a', text: "ログアウト"
          expect(page).not_to have_selector 'a', text: "アカウント登録"
          expect(page).not_to have_selector 'a', text: "ログイン"
        end
      end
    end
  end

  context 'with an existing account' do
    let!(:user) { create(:user, username: "ユーザー", email: 'user@example.com') }

    before { visit root_path }

    describe 'Sign Up' do
      it 'rejects creating the same user as an existing user' do
        within('header') do
          click_link 'アカウント登録'
        end

        expect(current_path).to eq new_user_registration_path

        within('.users-form') do
          fill_in "ユーザー名", with: "ユーザー"
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          fill_in "確認用パスワード", with: "password"
          expect { click_button "アカウント登録" }.to change(User, :count).by(0)
        end

        expect(title).to eq "アカウント登録 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector '.error-message'
        end
      end
    end

    describe 'Login/Logout' do
      it 'has login and logout pages working well' do
        within('header') do
          click_link 'ログイン'
        end

        expect(current_path).to eq new_user_session_path
        expect(title).to eq "ログイン | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector 'h2', text: "ログイン"
          expect(page).to have_field "メールアドレス"
          expect(page).to have_field "パスワード"
          expect(page).to have_button "ログイン"

          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: ""
          click_button "ログイン"
        end

        expect(current_path).to eq new_user_session_path

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('.users-form') do
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          click_button "ログイン"
        end

        expect(current_path).to eq root_path

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('header') do
          expect(page).to have_selector 'a', text: "ユーザー"
          expect(page).to have_selector 'a', text: "アカウント情報"
          expect(page).to have_selector 'a', text: "ログアウト"
          expect(page).not_to have_selector 'a', text: "アカウント登録"
          expect(page).not_to have_selector 'a', text: "ログイン"

          click_link "ログアウト"
        end

        expect(current_path).to eq root_path

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('header') do
          expect(page).to have_selector 'a', text: "アカウント登録"
          expect(page).to have_selector 'a', text: "ログイン"
          expect(page).not_to have_selector 'a', text: "アカウント情報"
          expect(page).not_to have_selector 'a', text: "ログアウト"
        end
      end
    end

    describe 'Edit' do
      it 'has a edit-user page working well' do
        sign_in user

        visit root_path

        within('header') do
          expect(page).to have_selector 'a', text: "ユーザー"
          expect(page).to have_selector 'a', text: "アカウント情報"
          expect(page).to have_selector 'a', text: "ログアウト"
          expect(page).not_to have_selector 'a', text: "アカウント登録"
          expect(page).not_to have_selector 'a', text: "ログイン"

          click_link "アカウント情報"
        end

        expect(current_path).to eq edit_user_registration_path
        expect(title).to eq "アカウント情報編集 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector 'h2', text: "アカウント情報変更"
          expect(page).to have_field "ユーザー名", with: "ユーザー"
          expect(page).to have_field "メールアドレス", with: "user@example.com"
          expect(page).to have_field "パスワード"
          expect(page).to have_field "確認用パスワード"
          expect(page).to have_field "現在のパスワード"
          expect(page).to have_button "保存"

          fill_in "ユーザー名", with: ""
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: ""
          fill_in "確認用パスワード", with: ""
          fill_in "現在のパスワード", with: ""
          click_button "保存"
        end

        expect(title).to eq "アカウント情報編集 | Mahjong Parlor"

        within('header') do
          expect(page).to have_selector 'a', text: "ユーザー"
        end

        within('.users-form') do
          expect(page).to have_selector '.error-message'

          fill_in "ユーザー名", with: "山田太郎"
          fill_in "メールアドレス", with: "taro@mahjong.com"
          fill_in "現在のパスワード", with: "password"
          click_button "保存"
        end

        expect(current_path).to eq root_path

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('header') do
          expect(page).to have_selector 'a', text: "山田太郎"

          click_link "アカウント情報"
        end

        within('.users-form') do
          expect(page).to have_field "ユーザー名", with: "山田太郎"
          expect(page).to have_field "メールアドレス", with: "taro@mahjong.com"

          fill_in "パスワード", with: "foobar"
          fill_in "確認用パスワード", with: "foobar"
          fill_in "現在のパスワード", with: "password"
          click_button "保存"
        end

        expect(current_path).to eq root_path

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('header') do
          click_link "ログアウト"

          click_link "ログイン"
        end

        within('.users-form') do
          fill_in "メールアドレス", with: "taro@mahjong.com"
          fill_in "パスワード", with: "foobar"
          click_button "ログイン"
        end

        expect(current_path).to eq root_path

        within('header') do
          expect(page).to have_selector 'a', text: "山田太郎"
        end
      end
    end

    describe 'Delete' do
      it 'destroys a user' do
        sign_in user
        visit edit_user_registration_path

        within('.nav-pills') do
          within('li.active') do
            expect(page).to have_link "アカウント情報編集", href: edit_user_registration_path
            expect(page).not_to have_link "アカウント削除", href: delete_user_path(user)
          end

          expect(page).to have_link "アカウント削除", href: delete_user_path(user)
          click_link "アカウント削除"
        end

        expect(current_path).to eq delete_user_path(user)
        expect(title).to eq "アカウント削除 | Mahjong Parlor"

        within('.nav-pills') do
          within('li.active') do
            expect(page).not_to have_link "アカウント情報編集", href: edit_user_registration_path
            expect(page).to have_link "アカウント削除", href: delete_user_path(user)
          end
        end

        within('.users-form') do
          expect(page).to have_button "アカウント削除"

          expect { click_button "アカウント削除" }.to change(User, :count).by(-1)
        end

        expect(current_path).to eq root_path

        within('header') do
          expect(page).to have_selector 'a', text: "アカウント登録"
          expect(page).to have_selector 'a', text: "ログイン"
          expect(page).not_to have_selector 'a', text: "アカウント情報"
          expect(page).not_to have_selector 'a', text: "ログアウト"

          click_link "ログイン"
        end

        expect(current_path).to eq new_user_session_path

        within('.users-form') do
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          click_button "ログイン"
        end

        expect(current_path).to eq new_user_session_path
        expect(page).to have_selector '.alert'
      end
    end

    describe 'Reset password' do
      after { ActionMailer::Base.deliveries.clear }

      it "changes user's password" do
        within('header') do
          click_link "ログイン"
        end

        within('.users-form') do
          click_link "こちらからパスワードを再発行してください"
        end

        expect(current_path).to eq new_user_password_path
        expect(title).to eq "パスワード再発行 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_field "メールアドレス"
          expect(page).to have_button "メール送信"

          fill_in "メールアドレス", with: ""
          click_button "メール送信"
        end

        expect(title).to eq "パスワード再発行 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector '.error-message'

          fill_in "メールアドレス", with: "user@example.com"
          expect { click_button "メール送信" }.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        expect(current_path).to eq new_user_session_path

        mail = ActionMailer::Base.deliveries.last
        url = extract_url_from(mail)
        visit url

        expect(current_path).to eq edit_user_password_path
        expect(title).to eq "パスワード再設定 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_field "新しいパスワード"
          expect(page).to have_field "新しいパスワード(確認用)"
          expect(page).to have_button "パスワード登録"

          fill_in "新しいパスワード", with: ""
          fill_in "新しいパスワード(確認用)", with: ""
          click_button "パスワード登録"
        end

        expect(title).to eq "パスワード再設定 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector '.error-message'

          fill_in "新しいパスワード", with: "foobar"
          fill_in "新しいパスワード(確認用)", with: "foobar"
          click_button "パスワード登録"
        end

        expect(current_path).to eq root_path

        within('header') do
          expect(page).to have_selector 'a', text: "ユーザー"

          click_link "ログアウト"
        end

        visit new_user_session_path

        within('.users-form') do
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          click_button "ログイン"
        end

        expect(current_path).to eq new_user_session_path

        expect(page).to have_selector '.alert'

        within('.users-form') do
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "foobar"
          click_button "ログイン"
        end

        expect(current_path).to eq root_path
      end
    end

    describe "Profile Page" do
      let(:other_user) { create(:user, content: "こんにちは") }
      let(:parlor) { create(:parlor) }
      let!(:user_reviews) { create_list(:review, 10, user: user, parlor: parlor) }
      let!(:other_user_reviews) { create_list(:review, 3, user: other_user, parlor: parlor) }
      let!(:user_comments) do
        create_list(:comment, 4, user: user, review: user_reviews[0])
      end
      let!(:other_user_comments) do
        create_list(:comment, 2, user: other_user, review: user_reviews[0])
      end
      let!(:users) { create_list(:user, 5) }

      before do
        users.each do |another_user|
          another_user.follow(user)
          other_user.follow(another_user)
        end

        3.times do |n|
          user.follow(users[n])
          users[n].follow(other_user)
        end
      end

      it "has user profile pages working well", js: true do
        visit user_path(user)

        expect(title).to eq "ユーザー | Mahjong Parlor"

        within('.user-detail') do
          expect(page).to have_text user.username
          expect(page).to have_text "まだ自己紹介文がありません"
          expect(page).not_to have_link "自己紹介を編集"
          expect(page).to have_text "投稿: 10"
          expect(page).to have_text "コメント: 4"
          expect(page).to have_text "フォロワー: 5"
          expect(page).to have_text "フォロー: 3"
          expect(page).not_to have_link "アカウント情報編集"

          within('#follow_form') do
            expect(page).not_to have_link "フォロー"
          end
        end

        expect(page).to have_selector '.review-index', count: 9

        click_on "次"
        expect(current_path).to eq user_path(user)
        expect(page).to have_selector '.review-index', count: 1

        visit user_path(other_user)

        expect(title).to eq "#{other_user.username} | Mahjong Parlor"

        within('.user-detail') do
          expect(page).to have_text user.username
          expect(page).to have_text "こんにちは"
          expect(page).not_to have_link "自己紹介を編集"
          expect(page).to have_text "投稿: 3"
          expect(page).to have_text "コメント: 2"
          expect(page).to have_text "フォロワー: 3"
          expect(page).to have_text "フォロー: 5"
          expect(page).not_to have_link "アカウント情報編集"

          within('#follow_form') do
            expect(page).not_to have_link "フォロー"
          end
        end

        expect(page).to have_selector '.review-index', count: 3

        sign_in user

        visit user_path(user)

        within('.user-detail') do
          expect(page).to have_text user.username
          expect(page).to have_text "まだ自己紹介文がありません"
          expect(page).to have_link "自己紹介を編集"
          expect(page).not_to have_selector 'textarea#user_content'
          expect(page).not_to have_button "保存"
          expect(page).to have_text "投稿: 10"
          expect(page).to have_text "コメント: 4"
          expect(page).to have_text "フォロワー: 5"
          expect(page).to have_text "フォロー: 3"
          expect(page).to have_link "アカウント情報編集", href: edit_user_registration_path

          within('#follow_form') do
            expect(page).not_to have_link "フォロー"
          end

          click_on "自己紹介を編集"

          expect(page).not_to have_link "自己紹介を編集"
          expect(page).to have_selector 'textarea#user_content'
          expect(page).to have_button "保存"

          find('textarea#user_content').fill_in with: "初めまして"
          click_on "保存"

          expect(page).to have_text "初めまして"
          expect(page).to have_link "自己紹介を編集"
          expect(page).not_to have_selector 'textarea#user_content'
          expect(page).not_to have_button "保存"
        end

        visit user_path(other_user)

        within('.user-detail') do
          expect(page).to have_text user.username
          expect(page).to have_text "こんにちは"
          expect(page).not_to have_link "自己紹介を編集"
          expect(page).to have_text "投稿: 3"
          expect(page).to have_text "コメント: 2"
          expect(page).to have_text "フォロワー: 3"
          expect(page).to have_text "フォロー: 5"
          expect(page).not_to have_link "アカウント情報編集"

          within('#follow_form') do
            expect(page).to have_link "フォロー"
          end

          within('#follow_form') do
            click_on "フォロー"
            expect(page).to have_link "フォロー解除"
          end

          expect(page).to have_text "フォロワー: 4"
        end

        visit user_path(user)

        within('.user-detail') do
          expect(page).to have_text "フォロー: 4"
        end

        visit user_path(other_user)

        within('.user-detail') do
          within('#follow_form') do
            click_on "フォロー解除"
            expect(page).to have_link "フォロー"
          end

          expect(page).to have_text "フォロワー: 3"
        end

        visit user_path(user)

        within('.user-detail') do
          expect(page).to have_text "フォロー: 3"
        end
      end
    end
  end

  context "with a test user account" do
    let!(:test_user) { create(:user, :test_user) }

    describe "Login as test user" do
      it 'clicks just test user login button' do
        visit new_user_session_path

        within('.users-form') do
          expect(page).to have_button "テストユーザー"

          click_button "テストユーザー"
        end

        expect(current_path).to eq root_path

        within('header') do
          expect(page).to have_selector 'a', text: "テストユーザー"
        end
      end
    end

    describe "Delete as test user" do
      it "is unable to delete the test user" do
        sign_in test_user
        visit delete_user_path(test_user)

        within('.users-form') do
          expect(page).to have_button "アカウント削除", disabled: true
        end
      end
    end
  end
end
