FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    username { 'user' }
    email { 'user@example.com' }
    password { 'password' }
  end
end
