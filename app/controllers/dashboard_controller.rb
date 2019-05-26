class DashboardController < ApplicationController
  def index
    if current_user.partner?
      @lockbox_partner = current_user.lockbox_partner
    else
      @lockbox_partners = LockboxPartner.all
    end
  end
end
