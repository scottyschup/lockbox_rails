class LockboxPartners::UsersController < ApplicationController
  before_action :set_lockbox_partner

  def new
    @user = @lockbox_partner.users.new
  end

  def create
    @user = @lockbox_partner.users.new(user_params)
    set_user_password
    if @user.save
      flash.clear
      redirect_to lockbox_partner_path(@lockbox_partner)
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def set_lockbox_partner
    @lockbox_partner = LockboxPartner.find(params[:lockbox_partner_id])
  end

  def set_user_password
    @user.password = Devise.friendly_token.first(12)
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
