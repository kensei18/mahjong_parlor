FactoryBot.define do
  factory :review do
    title { "良い" }
    content { "良いお店でした。" }
    overall { 4 }
    cleanliness { 5 }
    service { 4 }
    customer { 3 }
    user
    parlor
  end
end
