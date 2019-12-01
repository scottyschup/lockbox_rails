module LockboxPartnersHelper
  def days_since_last_reconciliation
    (Date.current - @lockbox_partner.reconciliation_interval_start).to_i
  end

  def status_display_text(status, support_request)
    if status == support_request.status
      (status.capitalize + " <i class='fa fa-check-circle'></i>").html_safe
    else
      status.capitalize
    end
  end
end
