require './lib/create_support_request'

class SupportRequestsController < ApplicationController
  def new
    @support_request = current_user.support_requests.build
    # We won't actually be calling any methods on the following two objects;
    # they're here so that the form helpers and params will work. This could
    # probably be refactored to make it cleaner
    @lockbox_action = @support_request.lockbox_actions.build
    @lockbox_transaction = @lockbox_action.lockbox_transactions.build
  end

  def create
    result = CreateSupportRequest.call(params: all_support_request_params)
    if result.success?
      @support_request = result.value
      # TODO redirect to support_requests#show, which doesn't exist yet
      redirect_to :root
    else
      render partial: 'shared/error', locals: { key: 'alert', value: result.failure }
    end
  end

  private

  def all_support_request_params
    support_request_params
      .merge(lockbox_action_params)
      .merge(lockbox_transaction_params)
      .merge(user_id: current_user.id)
      .merge(cost_breakdown: [lockbox_transaction_params])
  end

  def support_request_params
    params.require(:support_request).permit(
      :client_ref_id,
      :name_or_alias,
      :urgency_flag,
      :lockbox_partner_id
    )
  end

  def lockbox_action_params
    params.require(:lockbox_action).permit(
      :eff_date
    )
  end

  def lockbox_transaction_params
    params.require(:lockbox_transaction).permit(
      :amount_cents, :category
    )
  end
end
