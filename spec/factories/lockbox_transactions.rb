FactoryBot.define do
  factory :lockbox_transaction do
    balance_effect { 'debit' }
    amount_cents   { 100_00 }
    category       { LockboxTransaction::EXPENSE_CATEGORIES.sample }
    lockbox_action { build(:lockbox_action) }

    trait :for_add_cash do
      balance_effect { 'credit' }
    end
  end
end
