require './lib/create_support_request'

class SupportRequestsController < ApplicationController
  before_action :require_admin, except: [:create]

  def index
    @support_requests = SupportRequest.includes(:lockbox_partner, :user).pending.order("created_at desc")
  end

  def create
    merged_params = support_request_params.merge(user_id: current_user.id)
    result = CreateSupportRequest.call(params: merged_params)
    if result.success?
      @support_request = result.value
      redirect_to lockbox_partner_support_request_path(@support_request.lockbox_partner, @support_request)
    else
      render json: {
        error: render_to_string(
          partial: 'shared/error',
          locals: { key: 'alert', value: result.failure }
        )
      }
    end
  end

  private

  def support_request_params
    params.require(:support_request).permit(
      :client_ref_id,
      :name_or_alias,
      :urgency_flag,
      :lockbox_partner_id,
      lockbox_action_attributes: [
        :id,
        :eff_date,
        lockbox_transactions_attributes: [
          :id,
          :amount,
          :category,
          :distance,
          :_destroy # Virtual attribute used to delete records
        ]
      ]
    )
  end

end
