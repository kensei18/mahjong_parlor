FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    username { 'ユーザー' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
  end
end
