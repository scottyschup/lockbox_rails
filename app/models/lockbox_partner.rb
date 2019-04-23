class LockboxPartner < ApplicationRecord
  has_many :users
  has_many :lockbox_actions

  def balance(exclude_pending: false)
    relevant_transactions_for_balance(exclude_pending: exclude_pending).inject(Money.zero) do |balance, action|
      case action.balance_effect
      when 'credit'
        balance += action.amount
      when 'debit'
        balance -= action.amount
      end
      balance
    end
  end

  def relevant_transactions_for_balance(exclude_pending: false)
    excluded_statuses = exclude_pending ? %w(canceled pending) : %w(canceled)
    lockbox_action_ids = LockboxAction.where(lockbox_partner_id: self.id).where.not(status: excluded_statuses).pluck(:id)
    LockboxTransaction.where(lockbox_action_id: lockbox_action_ids)
  end
end
