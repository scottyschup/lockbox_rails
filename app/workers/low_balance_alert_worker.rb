class LowBalanceAlertWorker
  include Sidekiq::Worker

  def perform(lockbox_partner_id)
    partner = LockboxPartner.find_by(id: lockbox_partner_id)
    return unless partner
    LockboxPartnerMailer.with(lockbox_partner: partner).low_balance_alert.deliver_now
  end
end
