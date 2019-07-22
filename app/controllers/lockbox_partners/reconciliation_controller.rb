require 'reconciliation'

class LockboxPartners::ReconciliationController < ApplicationController
  before_action :set_lockbox_partner, :require_ownership

  def new
  end

  def create
    amount = Monetize.parse(reconciliation_params[:amount])
    action = Reconciliation.call(
      amount: amount,
      lockbox_partner: @lockbox_partner
    )
    if action.succeeded?
      redirect_to @lockbox_partner
    else
      render partial: 'shared/error', locals: { key: 'alert', value: action.failure }
    end
  end

  private

  def set_lockbox_partner
    @lockbox_partner = LockboxPartner.find(params[:lockbox_partner_id])
  end

  def reconciliation_params
    params.require(:reconciliation).permit(:amount)
  end

  def require_ownership
    if !current_user.admin? && current_user.lockbox_partner != @lockbox_partner
      return redirect_to root_path
    end
  end
end
