class DashboardController < ApplicationController
  before_action :set_lockbox_partner

  def index
    @lockbox_partners = @lockbox_partner.nil? ? LockboxPartner.all : nil
  end

  def onboarding_success
  end

  def support
  end

  private

  def set_lockbox_partner
    @lockbox_partner = current_user.partner? ? current_user.lockbox_partner : nil
  end
end
