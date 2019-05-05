class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :support_request, optional: true
  has_many :lockbox_transactions
  has_many :notes, as: :notable

  validates :eff_date, presence: true
  validates :support_request_id, presence: true, if: -> { action_type == :support_client }

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
