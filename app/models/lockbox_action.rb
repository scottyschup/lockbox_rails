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

  scope :excluding_statuses, -> (*statuses) { where.not(status: statuses) }

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
end
