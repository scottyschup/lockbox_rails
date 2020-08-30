# Raketasks to be called by Heroku Scheduler plugin
namespace :scheduled_tasks do
  desc "Queue reconciliation emails"
  task overdue_reconciliation_emails: :environment do
    next unless Date.today.monday?
    lockbox_partners = LockboxPartner.all
    lockbox_partners.each do |lockbox_partner|
      next unless lockbox_partner.reconciliation_severely_overdue?
      ReconciliationOverdueAlertMailerWorker.perform_async(lockbox_partner)
    end
  end
end