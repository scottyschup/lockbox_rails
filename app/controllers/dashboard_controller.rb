class DashboardController < ApplicationController
  def index
    if current_user.lockbox_partner_id?
      @lockbox_partner = LockboxPartner.find(current_user.lockbox_partner_id)
    else
      @lockbox_partners = LockboxPartner.all
    end
  end
end
