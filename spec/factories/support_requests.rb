FactoryBot.define do
  factory :support_request do
    association    :user
    association    :lockbox_partner
    name_or_alias  { Faker::Name.first_name }
    client_ref_id  { Faker::Alphanumeric.alpha(number: 8) }
  end

  trait(:pending) do
    lockbox_action { build(:lockbox_action) }
  end

  trait(:completed) do
    lockbox_action { build(:lockbox_action, :completed) }
  end

  trait(:canceled) do
    lockbox_action { build(:lockbox_action, :canceled) }
  end
end
