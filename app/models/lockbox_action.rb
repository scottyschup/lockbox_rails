class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  has_many :lockbox_transactions
  has_many :notes, as: :notable

  ACTION_TYPES = [
    :add_cash,
    :reconcile,
    :support_client
  ].freeze

  def amount
    lockbox_transactions.map(&:amount).sum
  end

  def cancel!
    update!(status: 'canceled')
  end

  def complete!
    update!(status: 'completed')
  end
end
