%w(
users
relationships
parlors
reviews
comments
favorites
likes
).each do |file|
  load(File.join(Rails.root, 'db', 'seeds', "#{file}.rb"))
end
