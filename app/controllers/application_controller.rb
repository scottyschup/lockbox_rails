class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def ensure_admin_only!
    if !current_user.admin? && current_user.lockbox_partner != @lockbox_partner
      return redirect_to root_path
    end
  end
end
