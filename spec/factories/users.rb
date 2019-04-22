FactoryBot.define do
  factory :user do
    name         { Faker::Name.full_name }
    email        { Faker::Internet.email }
    password     { 'superstrongpassword12345' }
    confirmed_at { Time.current }
  end
end