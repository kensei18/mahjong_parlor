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

reviews_count = Review.count
review_samples = (1..reviews_count).to_a

(reviews_count / 2).times do
  review = Review.find(review_samples.delete(review_samples.sample))
  5.times do
    review.comments.create(content: comments.sample,
                           user_id: (2..30).to_a.sample)
  end
end
