class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  has_many :lockbox_transactions
  has_many :notes, as: :notable

  STATUSES = [
    PENDING   = 'pending',
    COMPLETED = 'completed',
    CANCELED  = 'canceled'
  ].freeze

  ACTION_TYPES = [
    :add_cash,
    :reconcile,
    :support_client
  ].freeze

  # action_type should correspond with ACTION_TYPES
  def self.create_with_transactions(action_type, params)
    if !ACTION_TYPES.include?(action_type)
      raise ArgumentError.new("The only Lockbox actions supported are #{ACTION_TYPES.join(',')}")
    else
      ActiveRecord::Base.transaction do
        lockbox_action = create!(
          eff_date: params[:date],
          action_type: action_type,
          status: PENDING
        )

        case action_type
        when :add_cash
          lockbox_action.lockbox_transactions.create!(
            eff_date: params[:date],
            amount_cents: params[:amount_cents],
            balance_effect: 'credit'
          )
        when :reconcile
          expected_amount = lockbox_partner.expected_cash_in_box.cents
          return if expected_amount == params[:amount_cents]
          balance_effect = expected_amount > params[:amount_cents] ? 'debit' : 'credit'

          lockbox_action.lockbox_transactions.create!(
            eff_date: params[:date],
            amount_cents: params[:amount_cents],
            balance_effect: balance_effect,
            category: 'adjustment'
          )
        when :support_client
          params[:cost_breakdown].each do |item|
            lockbox_action.lockbox_transactions.create!(
              eff_date:       params[:date],
              amount_cents:   item[:amount_cents],
              balance_effect: 'debit',
              category:       item[:category]
            )
          end
        end
      end
    end
  end
end
