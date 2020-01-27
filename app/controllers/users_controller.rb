class UsersController < ApplicationController
  before_action :require_admin, :user_from_params

  def edit
  end

  def update
    @user.update(user_params)

    if @user.save
      flash.clear
      flash[:notice] = "User account for #{@user.email} has been updated."
      redirect_to root_path
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def user_from_params
    @user = User.find params[:id]
    redirect_back(fallback_location: root_path) unless @user
  end
end
