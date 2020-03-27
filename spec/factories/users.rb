FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    username { 'user' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
  end
end
