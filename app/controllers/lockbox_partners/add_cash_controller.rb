require 'add_cash_to_lockbox'

class LockboxPartners::AddCashController < ApplicationController
  before_action :set_lockbox_partner

  def new
  end

  def create
    action = AddCashToLockbox.call(
      lockbox_partner: LockboxPartner.find(add_cash_params[:lockbox_partner_id]),
      amount: add_cash_params[:amount],
      eff_date: Date.current
    )
    if action.succeeded?
      # TODO figure out what should happen
      redirect_to lockbox_partner_path(@lockbox_partner)
    else
      render 'new'
    end
  end

  private

  # TODO refactor this into a module
  def set_lockbox_partner
    @lockbox_partner = LockboxPartner.find(params[:lockbox_partner_id])
  end

  def add_cash_params
    params.require(:add_cash).permit(:lockbox_partner_id, :amount)
  end
end
