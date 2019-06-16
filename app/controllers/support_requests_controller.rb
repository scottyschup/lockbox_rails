require './lib/create_support_request'

class SupportRequestsController < LockboxPartners::SupportRequestsController
  def new
    @support_request = current_user.support_requests.build
    render "lockbox_partners/support_requests/new"
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
end
