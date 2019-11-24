require 'verbalize'

class CreateSupportRequest
  include Verbalize::Action

  # This is what params input looks like
  #
  # lockbox_partner_id: Integer
  # name_or_alias: String
  # user_id: Integer
  # client_ref_id: String
  # lockbox_action: {
  #   eff_date: Date,
  #   lockbox_transactions: [
  #     { amount: Money, category: String }
  #   ]
  # }
  input :params

  attr_accessor :support_request

  class ValidationError < StandardError; end

  def call
    ActiveRecord::Base.transaction do
      self.support_request = SupportRequest.create(
        lockbox_partner_id: params[:lockbox_partner_id],
        client_ref_id: params[:client_ref_id],
        name_or_alias: params[:name_or_alias],
        urgency_flag: params[:urgency_flag],
        user_id: params[:user_id]
      )

      unless support_request.valid? && support_request.persisted?
        raise ValidationError, support_request.errors.full_messages.join(', ')
      end

      lockbox_action = LockboxAction.create(
        eff_date: params[:lockbox_action][:eff_date],
        action_type: LockboxAction::SUPPORT_CLIENT,
        status: LockboxAction::PENDING,
        lockbox_partner_id: params[:lockbox_partner_id],
        support_request: support_request
      )

      unless lockbox_action.valid? && lockbox_action.persisted?
        raise ValidationError, lockbox_action.errors.full_messages.join(', ')
      end

      params[:lockbox_action][:lockbox_transactions]
        .reject { |lt| lt[:amount].blank? && lt[:category].blank? }
        .each do |item|
          lockbox_transaction = lockbox_action.lockbox_transactions.create(
            amount:   item[:amount],
            balance_effect: LockboxTransaction::DEBIT,
            category:       item[:category]
          )

          unless lockbox_transaction.valid? && lockbox_transaction.persisted?
            raise ValidationError, lockbox_transaction.errors.full_messages.join(', ')
          end
        end

      unless lockbox_action.lockbox_transactions.exists?
        raise ValidationError, "Amount must be greater than $0"
      end
    end

    support_request.record_creation
    send_creation_alert
    send_low_balance_alert if support_request.lockbox_partner.low_balance?

    support_request
  rescue CreateSupportRequest::ValidationError => err
    fail!(err.message)
  end

  def send_low_balance_alert
    LockboxPartnerMailer.with(lockbox_partner: support_request.lockbox_partner).low_balance_alert.deliver
  end

  def send_creation_alert
    SupportRequestMailer
      .with(support_request: support_request)
      .creation_alert
      .deliver_now
  end
end
