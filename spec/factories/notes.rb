FactoryBot.define do
  factory :note do
    text    { Faker::Lorem.paragraph }
    association :notable, factory: :user
    association :user
  end
end
