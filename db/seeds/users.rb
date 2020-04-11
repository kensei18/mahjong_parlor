User.create!(
  [
    {
      username: Rails.application.credentials.admin[:username],
      email: Rails.application.credentials.admin[:email],
      password: Rails.application.credentials.admin[:password],
      admin: true,
    },
    {
      username: "テストユーザー",
      email: "test@example.com",
      password: "password",
    }
  ]
)
