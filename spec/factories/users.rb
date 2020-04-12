FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    sequence(:username) { |n| "ユーザー#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }

    trait :test_user do
      id { 2 }
      username { "テストユーザー" }
      email { "test@example.com" }
    end
  end
end
