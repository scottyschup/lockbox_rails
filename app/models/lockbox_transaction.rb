class LockboxTransaction < ApplicationRecord
  monetize :amount_cents

  belongs_to :lockbox_action

  BALANCE_EFFECTS = [ :debit, :credit ].freeze

  EXPENSE_CATEGORIES = %w(
    gas
    parking
    transit
    childcare
    medicine
    food
    adjustment
  ).freeze
end
