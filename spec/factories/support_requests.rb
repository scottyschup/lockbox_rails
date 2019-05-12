FactoryBot.define do
  factory :support_request do
    association :user
    association :lockbox_partner
    name_or_alias { Faker::Name.first_name }
  end
end
