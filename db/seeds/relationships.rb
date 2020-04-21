15.times do |i|
  User.find(2).follow User.find(i + 3)
  15.times do |j|
    User.find(i + j + 3).follow User.find(i + 2)
  end
end
