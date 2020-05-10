namespace :overdue_reconciliation_notifications do
  desc "Queue an overdue reconciliation notification email if today is a Monday."
  task send_if_monday: :environment do
    return unless Time.current.monday?
    LockboxPartner.each do |partner|
      if partner.reconciliation_severely_overdue?
        LockboxPartnerMailer.with(lockbox_partner: partner).reconciliation_overdue_alert.deliver_later
      end
    end
  end
end
