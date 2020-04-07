class LowBalanceAlertWorker
  include Sidekiq::Worker

  def perform(params)
    return unless alert = params['alert']
    partner = LockboxPartner.find_by(id: params['lockbox_partner_id'])
    return unless partner

    case alert
    when 'insufficient_funds'
      LockboxPartnerMailer.with(lockbox_partner: partner).insufficient_funds_alert.deliver_now
    when 'low_balance'
      LockboxPartnerMailer.with(lockbox_partner: partner).low_balance_alert.deliver_now
    end
  end
end
