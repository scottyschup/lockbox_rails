# frozen_string_literal: true

class LockboxTransaction < ApplicationRecord
  monetize :amount_cents

  belongs_to :lockbox_action

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :category, presence: true
  has_paper_trail

  before_validation :default_values

  BALANCE_EFFECTS = [
    DEBIT  = 'debit',
    CREDIT = 'credit'
  ].freeze
  validates :balance_effect, inclusion: BALANCE_EFFECTS

  EXPENSE_CATEGORIES = [
    GAS                 = 'gas',
    PARKING             = 'parking',
    TRANSIT             = 'transit',
    CHILDCARE           = 'childcare',
    MEDICINE            = 'medicine',
    FOOD                = 'food',
    ADJUSTMENT          = 'adjustment',
    CASH_ADDITION       = 'cash_addition',
    HOTEL_REIMBURSEMENT = 'hotel_reimbursement'
  ].freeze
  validates :category, inclusion: EXPENSE_CATEGORIES

  def eff_date
    lockbox_action.eff_date
  end

  private

  def default_values
    self.balance_effect ||= DEBIT
  end
end
