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
          click_button "アカウント登録"
        end

        expect(title).to eq "アカウント登録 | Mahjong Parlor"

        within('.users-form') do
          expect(page).to have_selector '.error-message'

          fill_in "ユーザー名", with: "ユーザー"
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          fill_in "確認用パスワード", with: "password"
          click_button "アカウント登録"
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
    let!(:user) { create(:user, email: 'user@example.com') }

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
          click_button "アカウント登録"
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
  end
end
