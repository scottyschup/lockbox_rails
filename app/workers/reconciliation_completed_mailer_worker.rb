class ReconciliationCompletedMailerWorker
  include Sidekiq::Worker

  def perform(lockbox_partner_id, amount)
    lockbox_partner = LockboxPartner.find(lockbox_partner_id)
    return unless lockbox_partner
    LockboxPartnerMailer.with(lockbox_partner: lockbox_partner, amount: amount)
      .reconciliation_completed_alert
      .deliver_now
  end
end