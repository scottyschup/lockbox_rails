module LockboxPartnersHelper
  def days_since_last_reconciliation
    (Date.current - @lockbox_partner.reconciliation_interval_start).to_i
  end

  def status_display_text(status, support_request)
    icon_html = if status == support_request.status
      "<i class='fa fa-check'></i>"
    else
      "<i class='icon-spacer'></i>"
    end
    (icon_html + " " + status.capitalize).html_safe
  end
end
