# frozen_string_literal: true

class LockboxTransaction < ApplicationRecord
  monetize :amount_cents

  belongs_to :lockbox_action

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :category, presence: true
  has_paper_trail

  BALANCE_EFFECTS = [
    DEBIT  = 'debit',
    CREDIT = 'credit'
  ].freeze

  EXPENSE_CATEGORIES = [
    GAS           = 'gas',
    PARKING       = 'parking',
    TRANSIT       = 'transit',
    CHILDCARE     = 'childcare',
    MEDICINE      = 'medicine',
    FOOD          = 'food',
    ADJUSTMENT    = 'adjustment',
    CASH_ADDITION = 'cash_addition'
  ].freeze

  def eff_date
    lockbox_action.eff_date
  end
end
