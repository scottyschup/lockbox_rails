class AdminDashboardController < ApplicationController
  before_action :require_admin

  def index
    @users = admin_users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: {
        users: render_to_string(
          partial: 'admin_dashboard/users',
          locals: {
            users: admin_users
          }
        )
      }
    else
      render json: {
        error: render_to_string(
          partial: 'shared/error',
          locals: {
            key: 'alert',
            value: @user.errors.full_messages.join(', ')
          }
        )
      }
    end
  end

  private

  def admin_users
    User.admin.order(created_at: :desc)
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end