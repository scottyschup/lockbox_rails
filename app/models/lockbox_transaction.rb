class LockboxTransaction < ApplicationRecord
  monetize :amount_cents

  belongs_to :lockbox_action

  BALANCE_EFFECTS = [
    DEBIT  = :debit,
    CREDIT = :credit
  ].freeze

  EXPENSE_CATEGORIES = [
    GAS        = 'gas',
    PARKING    = 'parking',
    TRANSIT    = 'transit',
    CHILDCARE  = 'childcare',
    MEDICINE   = 'medicine',
    FOOD       = 'food',
    ADJUSTMENT = 'adjustment'
  ].freeze
end
