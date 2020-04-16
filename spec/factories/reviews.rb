FactoryBot.define do
  factory :review do
    title { "良い" }
    content { "良いお店でした" }
    overall { 5 }
    cleanliness { 5 }
    service { 5 }
    customer { 5 }
    user
    parlor
  end
end
