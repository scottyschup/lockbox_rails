require 'verbalize'

class AddCashToLockbox
  include Verbalize::Action

  input :lockbox_partner, :eff_date, :amount_cents

  def call
    result = ActiveRecord::Base.transaction do
      lockbox_action = lockbox_partner.lockbox_actions.create(
        eff_date: eff_date,
        action_type: :add_cash,
        status: LockboxAction::PENDING
      )

      unless lockbox_action.valid?
        err_message = "Lockbox action not created: #{lockbox_action.errors.full_messages.join(', ')}"
        fail!(err_message)
      end

      lockbox_transaction = lockbox_action.lockbox_transactions.create(
        eff_date: eff_date,
        amount_cents: amount_cents,
        balance_effect: LockboxTransaction::CREDIT
      )

      unless lockbox_transaction.valid?
        err_message = "Lockbox transaction not created: #{lockbox_transaction.errors.full_messages.join(', ')}"
        fail!(err_message)
      end
    end

    if result
      LockboxActionMailer
        .with(lockbox_partner: lockbox_partner, lockbox_action: lockbox_action)
        .add_cash_email
        .deliver_now
    end
  end
end
