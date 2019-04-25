FactoryBot.define do
  factory :user do
    name         { Faker::Name.name }
    email        { Faker::Internet.email }
    password     { 'superstrongpassword12345' }
    confirmed_at { Time.current }
  end
end