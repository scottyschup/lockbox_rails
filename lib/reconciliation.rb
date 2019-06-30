require 'verbalize'

class Reconciliation
  include Verbalize::Action

  input :lockbox_partner, :amount

  def call
    # The :amount input is the actual amount of money in the lockbox and must be
    # a Money object
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
        difference = expected_amount - amount
        balance_effect = if difference.positive?
          LockboxTransaction::CREDIT
        else
          LockboxTransaction::DEBIT
        end

        lockbox_transaction = lockbox_action.lockbox_transactions.create!(
          amount: difference,
          balance_effect: balance_effect
        )

        unless lockbox_transaction.valid?
          err_message = "Lockbox transaction not created: #{lockbox_transaction.errors.full_messages.join(', ')}"
          raise ActiveRecord::Rollback
        end
      end
      lockbox_action
    end

    result ? result : fail!(err_message)
  end
end
