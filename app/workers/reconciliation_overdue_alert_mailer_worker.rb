class ReconciliationOverdueAlertMailerWorker
  include Sidekiq::Worker

  def perform(lockbox_partner_id)
    lockbox_partner = LockboxPartner.find(lockbox_partner_id)
    return unless lockbox_partner
    LockboxPartnerMailer.with(lockbox_partner: lockbox_partner)
      .reconciliation_overdue_alert
      .deliver_now
  end
end