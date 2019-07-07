module LockboxPartnersHelper
  def days_since_last_reconciliation
    (Date.current - @lockbox_partner.reconciliation_interval_start).to_i
  end
end
