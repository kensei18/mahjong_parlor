20.times do |i|
  user = User.find(i + 2)
  reviews = Review.all.sample(8)
  user.like reviews
end
