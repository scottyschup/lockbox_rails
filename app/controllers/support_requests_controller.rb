require './lib/create_support_request'

class SupportRequestsController < LockboxPartners::SupportRequestsController

  def create
    # binding.pry
    result = CreateSupportRequest.call(params: all_support_request_params)
    if result.success?
      @support_request = result.value
      redirect_to lockbox_partner_support_request_path(@support_request.lockbox_partner, @support_request)
    else
      render partial: 'shared/error', locals: { key: 'alert', value: result.failure }
    end
  end

  private

  def all_support_request_params
    support_request_params
      .merge(lockbox_action: lockbox_action_params)
      .merge(user_id: current_user.id)
  end

end
