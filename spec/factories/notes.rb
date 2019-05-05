FactoryBot.define do
  factory :note do
    text    { Faker::Lorem.paragraph }
    association :notable, factory: :user
  end
end
