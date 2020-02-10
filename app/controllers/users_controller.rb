class UsersController < ApplicationController
  before_action :require_account_ownership

  def edit
  end

  def update
    @user.update(user_params)

    if @user.save
      flash.clear
      flash[:notice] = "User account for #{@user.email} has been updated."
      redirect_to(root_path)
    end

    flash[:alert] = @user.errors.full_messages.join(", ")
    redirect_back(fallback_location: root_path)
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def require_account_ownership
    @user = User.find(params[:id])
    return if @user == current_user

    flash[:error] = "You are not authorized to access this page."
    redirect_back(fallback_location: root_path)
  end
end
