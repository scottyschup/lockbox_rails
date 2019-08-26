require 'verbalize'

class CreateSupportRequest
  include Verbalize::Action

  # This is what params input looks like
  #
  # lockbox_partner_id: Integer
  # name_or_alias: String
  # user_id: Integer
  # client_ref_id: String
  # lockbox_action: [
  #   {
  #     eff_date: Date,
  #     lockbox_transactions: [
  #       { amount: Money, category: String }
  #     ]
  #   }
  # ]
  input :params

  attr_accessor :support_request

  def call
    ActiveRecord::Base.transaction do
      self.support_request = SupportRequest.create(
        lockbox_partner_id: params[:lockbox_partner_id],
        client_ref_id: params[:client_ref_id],
        name_or_alias: params[:name_or_alias],
        user_id: params[:user_id]
      )

      fail!(support_request.errors.full_messages.join(', ')) unless support_request.valid?

      lockbox_action = LockboxAction.create(
        eff_date: params[:lockbox_action][:eff_date],
        action_type: LockboxAction::SUPPORT_CLIENT,
        status: LockboxAction::PENDING,
        lockbox_partner_id: params[:lockbox_partner_id],
        support_request: support_request
      )

      fail!(lockbox_action.errors.full_messages.join(', ')) unless lockbox_action.valid?

      params[:lockbox_action][:lockbox_transactions]
        .select { |lt| lt[:amount] != "" }
        .each do |item|
        lockbox_action.lockbox_transactions.create(
          amount:   item[:amount],
          balance_effect: LockboxTransaction::DEBIT,
          category:       item[:category]
        )
      end
    end

    send_low_balance_alert if support_request.lockbox_partner.low_balance?

    support_request
  end

  def send_low_balance_alert
    LockboxPartnerMailer.with(lockbox_partner: support_request.lockbox_partner).low_balance_alert.deliver
  end
end
