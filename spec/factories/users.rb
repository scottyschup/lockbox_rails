FactoryBot.define do
  factory :user do
    name         { Faker::Name.name }
    email        { Faker::Internet.email }
    password     { 'superstrongpassword12345' }
    confirmed_at { Time.current }
    role         { 'admin' }
    time_zone    { 'America/Chicago' }

    trait :partner_user do
      role { 'partner' }
    end
  end
end
