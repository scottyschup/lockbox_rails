FactoryBot.define do
  factory :lockbox_partner do
    name         { Faker::Company.name }
    address      { Faker::Address.full_address }
    phone_number { Faker::PhoneNumber.phone_number }

    trait :active do
      # The user needs to be confirmed, but currently the user factory does this
      # by default
      users { build_list :user, 1 }
      lockbox_actions { build_list :lockbox_action, 1, :add_cash, :completed }
    end
  end
end
