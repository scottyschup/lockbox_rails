require 'verbalize'

class CreateSupportRequest
  include Verbalize::Action

  input :params

  def call
    ActiveRecord::Base.transaction do
      support_req = SupportRequest.create(
        lockbox_partner_id: params[:lockbox_partner_id],
        name_or_alias: params[:name_or_alias],
        user_id: params[:user_id]
      )

      fail!(support_req.errors.full_messages.join(', ')) unless support_req.valid?

      lockbox_action = LockboxAction.create(
        eff_date: params[:lockbox_action][:eff_date],
        action_type: LockboxAction::SUPPORT_CLIENT,
        status: LockboxAction::PENDING,
        lockbox_partner_id: params[:lockbox_partner_id],
        support_request: support_req
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

      support_req
    end
  end
end
