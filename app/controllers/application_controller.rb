class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def require_admin_user
    return redirect_to index_path unless current_user&.admin?
  end

  def require_clinic_user
    return redirect_to index_path unless current_user&.partner?
  end
end
