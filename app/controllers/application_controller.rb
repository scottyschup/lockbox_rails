class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def ensure_admin_only!  if !current_user.admin? && current_user.lockbox_partner != @lockbox_partner
    flash[:error] = "You are not authorized to access this page"
    return redirect_to root_path
  end

  def require_admin
    unless current_user.admin?
      flash[:error] = "You are not authorized to access this page"
      return redirect_to root_path
    end
  end
end
