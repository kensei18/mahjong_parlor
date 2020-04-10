require 'rails_helper'

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

        expect(title).to eq "Mahjong Parlor"

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

        expect(title).to eq "アカウント登録 | Mahjong Parlor"

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

        expect(title).to eq "ログイン | Mahjong Parlor"

        within('.content-wrapper') do
          expect(page).to have_selector '.alert'
        end

        within('.users-form') do
          fill_in "メールアドレス", with: "user@example.com"
          fill_in "パスワード", with: "password"
          click_button "ログイン"
        end

        expect(title).to eq "Mahjong Parlor"

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

        expect(title).to eq "Mahjong Parlor"

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

        expect(title).to eq "Mahjong Parlor"

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

        expect(title).to eq "Mahjong Parlor"

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

        expect(title).to eq "Mahjong Parlor"

        within('header') do
          expect(page).to have_selector 'a', text: "山田太郎"
        end
      end
    end
  end
end
