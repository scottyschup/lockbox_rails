FactoryBot.define do
  factory :lockbox_partner do
    name         { Faker::Company.name }
    address      { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
