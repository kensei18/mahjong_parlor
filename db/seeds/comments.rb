comments = %w(
参考になりました！
ぜひ行きたいです！
ここ行ったことないので、気になります！
ここにはどれくらいの頻度でいらしていますか？？
渋谷で雀荘探していたので、ありがたいです！！！
そうかなぁ。。。
ここ良いですよね\(^o^\)
今度是非同卓したいですね\(^-^\)
行かれたのは何曜日でしたか？
どれくらい混んでいましたか？
天鳳３段なのですが、フリーで参加しても大丈夫そうですか？
とりま行ってみます！！
)

Review.count.times do |i|
  review = Review.find(i + 1)
  5.times do |j|
    review.comments.create(content: comments.sample,
                           user_id: j + 3)
  end
end
