User.create!(
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
    }
  ]
)
