require 'verbalize'

class Reconciliation
  include Verbalize::Action

  input :lockbox_partner, :amount

  def call
    # The :amount input is the actual amount of money in the lockbox. We should
    # handle conversion to Money outside of this class, to avoid making
    # assumptions about the form
    fail!("Amount is invalid") unless amount.is_a?(Money)
    expected_amount = lockbox_partner.balance(exclude_pending: true)
    err_message = nil

    result = ActiveRecord::Base.transaction do
      lockbox_action = lockbox_partner.lockbox_actions.create!(
        action_type: LockboxAction::RECONCILE,
        eff_date: Date.current,
        status: LockboxAction::COMPLETED
      )

      unless lockbox_action.valid?
        err_message = "Lockbox action not created: #{lockbox_action.errors.full_messages.join(', ')}"
        raise ActiveRecord::Rollback
      end

      if amount != expected_amount
        difference = amount - expected_amount

        lockbox_transaction = lockbox_action.lockbox_transactions.create!(
          amount: difference.abs,
          balance_effect: balance_effect(difference),
          category: LockboxTransaction::ADJUSTMENT
        )

        unless lockbox_transaction.valid?
          err_message = "Lockbox transaction not created: #{lockbox_transaction.errors.full_messages.join(', ')}"
          raise ActiveRecord::Rollback
        end
      end

      ReconciliationCompletedMailerWorker.perform_async(lockbox_partner.id, amount)
      lockbox_action
    end

    result ? result : fail!(err_message)
  end

  private

  def balance_effect(difference)
    difference.positive? ? LockboxTransaction::CREDIT : LockboxTransaction::DEBIT
  end
end
