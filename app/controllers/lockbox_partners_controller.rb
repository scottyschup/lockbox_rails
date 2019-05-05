class LockboxPartnersController < ApplicationController
  def new
    @lockbox_partner = LockboxPartner.new
  end

  def create
    @lockbox_partner = LockboxPartner.new(lockbox_params)
    if @lockbox_partner.save
      redirect_to '/', notice: 'Lockbox Partner was successfully created.'
    else
      render :new
    end
  end

  def show
    @lockbox_partner = LockboxPartner.find(params[:id])
  end

  private

  def lockbox_params
    params.require(:lockbox_partner).permit(:name, :address, :phone_number)
  end
end
