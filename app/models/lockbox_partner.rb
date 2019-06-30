class LockboxPartner < ApplicationRecord
  has_many :users
  has_many :lockbox_actions

  # Number of days since last reconciliation when clinic user will be prompted
  # to reconcile the lockbox. TODO make this configurable
  RECONCILIATION_INTERVAL = 30

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
    lockbox_action_ids = LockboxAction.where(lockbox_partner: self).excluding_statuses(excluded_statuses).pluck(:id)
    LockboxTransaction.where(lockbox_action_id: lockbox_action_ids)
  end

  def active?
    users.confirmed.exists? && lockbox_actions.completed_cash_additions.exists?
  end

  def historical_actions
    @all_actions ||= lockbox_actions.order(eff_date: :desc)
  end

  def reconciliation_needed?
    return false unless persisted?
    # If the lockbox has never been reconciled, start counting from the date it
    # was created
    interval_start = last_reconciled_at || created_at
    interval_start <= RECONCILIATION_INTERVAL.days.ago
  end

  def last_reconciled_at
    lockbox_actions.where(action_type: LockboxAction::RECONCILE)
                   .order(eff_date: :desc)
                   .first
                   &.eff_date
  end
end
