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

    trait :images_attached do
      after(:build) do |review|
        review.images.attach(io:
                               File.open(
                                 Rails.root.join('spec', 'factories', 'images', 'test.png')
                               ),
                             filename: 'test.png')
      end
    end
  end
end
