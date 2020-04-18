15.times do |i|
  15.times do |j|
    User.find(i + j + 3).follow User.find(i + 2)
  end
end
