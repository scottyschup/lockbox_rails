class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  def require_admin
    unless current_user&.admin?
      flash[:error] = "You are not authorized to access this page"
      return redirect_to root_path
    end
  end

  def require_admin_or_ownership
    return if current_user.admin?
    return if current_user.lockbox_partner == @lockbox_partner
    flash[:alert] = "You are not authorized to access this page"
    return redirect_to root_path
  end
end
