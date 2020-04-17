FactoryBot.define do
  factory :comment do
    content { "参考になった" }
    user
    review
  end
end
