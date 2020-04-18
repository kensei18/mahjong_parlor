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

contents = %W(
麻雀大好き！！！
天鳳#{(2..9).to_a.sample}段になりました！！
まだまだ初心者ですが、よろしくお願いします！
渋谷近辺の雀荘によく行きます
基本は#{%w(セット フリー).sample}で入ります
まだ一人では入ったことがないので、このサイトを参考にしたいです！
フリーで上手くなりたいです！！
)

40.times do |n|
  username = Faker::Name.name
  email = "user#{n}@example.com"
  User.create(
    username: username,
    email: email,
    password: "password",
    content: contents.sample
  )
end
