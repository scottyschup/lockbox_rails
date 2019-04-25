class DashboardController < ApplicationController
  def index
    @lockbox_partners = LockboxPartner.all
  end
end
