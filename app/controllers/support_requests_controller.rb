class SupportRequestsController < ApplicationController
  def new
    @support_requests = current_user.support_requests.build
  end

  def create
    @support_request = current_user.support_requests.new(support_request_params)
    if @support_request.save
      # TODO redirect to support_requests#show, which doesn't exist yet
      redirect_to :root_path
    else
      render :new
    end
  end

  private

  def support_request_params
    params.require(:support_request).permit(
      :client_ref_id,
      :name_or_alias,
      :urgency_flag,
      :lockbox_partner_id
    )
  end
end
