class LockboxPartnerMailer < ApplicationMailer
  def insufficient_funds_alert
    email_address = ENV['LOCKBOX_EMAIL']
    return unless email_address.present?
    subject = %Q(
      [INSUFFICIENT LOCKBOX FUNDS] #{params[:lockbox_partner].name} can't cover
      pending support requests
    ).strip

    mail(to: email_address, subject: subject)
  end

  def low_balance_alert
    email_address = ENV['LOW_BALANCE_ALERT_EMAIL']
    return unless email_address.present?
    subject = "[LOW LOCKBOX BALANCE] #{params[:lockbox_partner].name} needs cash"

    mail(to: email_address, subject: subject)
  end
end
