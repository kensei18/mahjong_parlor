%w(
users
parlors
reviews
comments
).each do |file|
  load(File.join(Rails.root, 'db', 'seeds', "#{file}.rb"))
end
