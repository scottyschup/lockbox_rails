class LockboxPartnerMailer < ApplicationMailer
  def insufficient_funds_alert
    @lockbox_partner = params[:lockbox_partner]
    email_address = ENV['LOCKBOX_EMAIL']
    return unless email_address.present?
    admin_emails = User.get_admin_emails
    subject = %Q(
      [INSUFFICIENT LOCKBOX FUNDS] #{@lockbox_partner.name} can't cover
      pending support requests
    ).strip

    mail(to: email_address, cc: admin_emails, subject: subject)
  end

  def low_balance_alert
    @lockbox_partner = params[:lockbox_partner]
    email_address = [ENV['LOW_BALANCE_ALERT_EMAIL'], ENV['LOCKBOX_EMAIL']].join(",")
    return unless email_address.present?
    admin_emails = User.get_admin_emails
    subject = "[LOW LOCKBOX BALANCE] #{@lockbox_partner.name} needs cash"

    mail(to: email_address, cc: admin_emails, subject: subject)
  end
end
