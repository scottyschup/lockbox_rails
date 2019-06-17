require './lib/create_support_request'

class LockboxPartners::SupportRequestsController < ApplicationController

  def new
    if params[:lockbox_partner_id]
      @lockbox_partner = LockboxPartner.find(params[:lockbox_partner_id])
    end
    @support_request = current_user.support_requests.build
  end

  def create
    result = CreateSupportRequest.call(params: all_support_request_params)
    if result.success?
      @support_request = result.value
      redirect_to lockbox_partner_support_request_path(@support_request.lockbox_partner, @support_request)
    else
      render partial: 'shared/error', locals: { key: 'alert', value: result.failure }
    end
  end

  def show
    @support_request = SupportRequest.find(params[:id])
  end

  private

  def all_support_request_params
    support_request_params
      .merge(lockbox_action: lockbox_action_params)
      .merge(user_id: current_user.id)
      .merge(lockbox_partner_id: params[:lockbox_partner_id])
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
      :eff_date,
      lockbox_transactions: [
        :amount,
        :category
      ]
    )
  end
end
