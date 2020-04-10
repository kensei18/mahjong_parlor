FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    username { 'ユーザー' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }

    trait :test_user do
      username { "テストユーザー" }
      email { "test@example.com" }
    end
  end
end
