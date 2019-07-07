FactoryBot.define do
  factory :support_request do
    association    :user
    association    :lockbox_partner
    name_or_alias  { Faker::Name.first_name }
    client_ref_id  { Faker::Alphanumeric.alpha(8) }
  end
end
