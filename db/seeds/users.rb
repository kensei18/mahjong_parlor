User.create(
  [
    {
      id: 1,
      username: Rails.application.credentials.admin[:username],
      email: Rails.application.credentials.admin[:email],
      password: Rails.application.credentials.admin[:password],
      admin: true,
    },
    {
      id: 2,
      username: "テストユーザー",
      email: "test@example.com",
      password: "password",
    },
  ]
)

30.times do |n|
  username = Faker::Name.name
  email = "user#{n}@example.com"
  User.create(
    username: username,
    email: email,
    password: "password"
  )
end
