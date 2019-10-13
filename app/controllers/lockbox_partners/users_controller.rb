class LockboxPartners::UsersController < ApplicationController
  before_action :set_lockbox_partner, :require_admin_or_ownership

  def new
    @user = @lockbox_partner.users.new
  end

  def create
    @user = @lockbox_partner.users.new(user_params)
    set_user_password
    set_user_role
    if @user.save
      flash.clear
      flash[:notice] = "New user created for Lockbox Partner #{@lockbox_partner.name}"
      redirect_to lockbox_partner_users_path(@lockbox_partner)
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :index
    end
  end

  def index
    @new_user = @lockbox_partner.users.new
    @users = @lockbox_partner.users.all
  end

  private

  def set_lockbox_partner
    @lockbox_partner = LockboxPartner.find(params[:lockbox_partner_id])
  end

  def set_user_password
    @user.password = Devise.friendly_token.first(12)
  end

  def set_user_role
    @user.role = User::PARTNER
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
