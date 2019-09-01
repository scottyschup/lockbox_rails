class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def require_admin
    unless current_user&.admin?
      flash[:error] = "You are not authorized to access this page"
      return redirect_to root_path
    end
  end
end
