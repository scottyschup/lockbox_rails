require 'verbalize'

class AddCashToLockbox
  include Verbalize::Action

  input :lockbox_partner, :eff_date, :amount_cents

  def call
    err_message = nil

    result = ActiveRecord::Base.transaction do
      lockbox_action = lockbox_partner.lockbox_actions.create(
        eff_date: eff_date,
        action_type: LockboxAction::ADD_CASH,
        status: LockboxAction::PENDING
      )

      unless lockbox_action.valid?
        err_message = "Lockbox action not created: #{lockbox_action.errors.full_messages.join(', ')}"
        raise ActiveRecord::Rollback
      end

      lockbox_transaction = lockbox_action.lockbox_transactions.create(
        eff_date: eff_date,
        amount_cents: amount_cents,
        balance_effect: LockboxTransaction::CREDIT
      )

      unless lockbox_transaction.valid?
        err_message = "Lockbox transaction not created: #{lockbox_transaction.errors.full_messages.join(', ')}"
        raise ActiveRecord::Rollback
      end

      lockbox_action
    end

    if result
      LockboxActionMailer
        .with(lockbox_partner: lockbox_partner, lockbox_action: result)
        .add_cash_email
        .deliver_now
      result # Return the lockbox action
    else
      fail!(err_message)
    end
  end
end
