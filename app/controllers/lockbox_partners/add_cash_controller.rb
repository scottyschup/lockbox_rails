require 'add_cash_to_lockbox'

class LockboxPartners::AddCashController < ApplicationController
  before_action :set_lockbox_partner, :require_admin

  def new
  end

  def create
    action = AddCashToLockbox.call(
      lockbox_partner: @lockbox_partner,
      amount: add_cash_params[:amount],
      tracking_number: add_cash_params[:tracking_number],
      delivery_method: add_cash_params[:delivery_method],
      eff_date: Date.current
    )
    if action.succeeded?
      formatted_amount = "%0.2f" % action.value.amount.to_f
      flash[:notice] = "Success! $#{formatted_amount} added to #{@lockbox_partner.name} lockbox."
      redirect_to lockbox_partner_path(@lockbox_partner)
    else
      flash[:alert] = "Sorry, there was a problem."
      render 'new'
    end
  end

  private

  # TODO refactor this into a module
  def set_lockbox_partner
    @lockbox_partner = LockboxPartner.find(params[:lockbox_partner_id])
  end

  def add_cash_params
    params.require(:add_cash).permit(:amount, :tracking_number, :delivery_method)
  end
end
