FactoryBot.define do
  factory :parlor do
    sequence(:name) { |n| "しぶとん#{n}" }
    address { "東京都渋谷区道玄坂２丁目１０−１２" }
    latitude { 35.6588497 }
    longitude { 139.6990777 }
    smoking { 1 }
    website { "http://www.shibuton.jp/" }

    trait :shibuton do
      name { "しぶとん" }
    end
  end
end
