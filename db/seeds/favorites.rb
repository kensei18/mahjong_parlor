20.times do |i|
  user = User.find(i + 2)
  parlors = Parlor.all.sample(4)
  user.add_to_favorites parlors
end
