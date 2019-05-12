class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :support_request, optional: true
  has_many :lockbox_transactions
  has_many :notes, as: :notable

  validates :eff_date, presence: true
  validates :support_request_id, presence: true, if: -> { action_type == 'support_client' }

  before_validation :inherit_lockbox_partner_id

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

  scope :excluding_statuses, -> (*statuses) { where.not(status: statuses) }

  # action_type should correspond with ACTION_TYPES
  def self.create_with_transactions(action_type, params)
    if !ACTION_TYPES.include?(action_type)
      raise ArgumentError.new("The only Lockbox actions supported are #{ACTION_TYPES.join(',')}")
    else
      ActiveRecord::Base.transaction do
        lockbox_action = create!(
          eff_date: params[:eff_date],
          action_type: action_type,
          status: PENDING
        )

        case action_type
        when :add_cash
          lockbox_action.lockbox_transactions.create!(
            eff_date: params[:eff_date],
            amount_cents: params[:amount_cents],
            balance_effect: LockboxTransaction::CREDIT
          )
        when :reconcile
          expected_amount = lockbox_partner.expected_cash_in_box.cents
          return if expected_amount == params[:amount_cents]

          balance_effect = if expected_amount > params[:amount_cents]
            LockboxTransaction::DEBIT
          else
            LockboxTransaction::CREDIT
          end

          lockbox_action.lockbox_transactions.create!(
            eff_date: params[:eff_date],
            amount_cents: params[:amount_cents],
            balance_effect: balance_effect,
            category: LockboxTransation::ADJUSTMENT
          )
        when :support_client
          params[:cost_breakdown].each do |item|
            lockbox_action.lockbox_transactions.create!(
              eff_date:       params[:eff_date],
              amount_cents:   item[:amount_cents],
              balance_effect: LockboxTransaction::DEBIT,
              category:       item[:category]
            )
          end
        end

        lockbox_action
      end
    end
  end

  def amount
    return Money.zero if canceled?
    return Money.zero if lockbox_transactions.none?
    lockbox_transactions.map(&:amount).sum
  end

  def pending?
    status == PENDING
  end

  def completed?
    status == COMPLETED
  end

  def canceled?
    status == CANCELED
  end

  def cancel!
    update!(status: CANCELED)
  end

  def complete!
    update!(status: COMPLETED)
  end

  private

  def inherit_lockbox_partner_id
    if lockbox_partner_id.blank? && support_request&.lockbox_partner_id
      self.lockbox_partner_id = support_request.lockbox_partner_id
    end
  end
end
