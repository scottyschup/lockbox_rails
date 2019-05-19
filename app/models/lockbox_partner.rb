class LockboxPartner < ApplicationRecord
  has_many :users
  has_many :lockbox_actions

  scope :active, -> { with_active_user.with_initial_cash }
  scope :with_active_user, -> { joins(:users).merge(User.confirmed) }

  scope :with_initial_cash, -> do
    # returns partners that have had cash successfully added at least once
    joins(:lockbox_actions).merge(LockboxAction.completed_cash_additions)
  end

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
    excluded_statuses = [ LockboxAction::CANCELED ]
    excluded_statuses << LockboxAction::PENDING if exclude_pending
    lockbox_action_ids = LockboxAction.excluding_statuses(excluded_statuses).pluck(:id)
    LockboxTransaction.where(lockbox_action_id: lockbox_action_ids)
  end

  def active?
    users.confirmed.exists? && lockbox_actions.completed_cash_additions.exists?
  end
end
