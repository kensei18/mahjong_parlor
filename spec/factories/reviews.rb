FactoryBot.define do
  factory :review do
    title { "良い" }
    content { "良いお店でした。" }
    smoking { 0 }
    cleanliness { 5 }
    service { 4 }
    customer { 3 }
    user
    parlor
  end
end
