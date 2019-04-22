FactoryBot.define do
  factory :lockbox_transaction do
    eff_date       { Date.current }
    balance_effect { 'debit' }
    amount         { 100_00 }

    trait :for_add_cash do
      balance_effect { 'credit' }
    end
  end
end
