FactoryBot.define do
  factory :note do
    text    { Faker::Lorem.paragraph }
    notable { create(:user) }
  end
end
