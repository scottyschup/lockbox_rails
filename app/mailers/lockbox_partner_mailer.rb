class LockboxPartnerMailer < ApplicationMailer
  def low_balance_alert
    return unless ENV['LOW_BALANCE_ALERT_EMAIL'].present?

    @lockbox_partner = params[:lockbox_partner]
    mail(to: ENV['LOW_BALANCE_ALERT_EMAIL'], subject: "[LOW LOCKBOX BALANCE] #{@lockbox_partner.name} needs cash")
  end
end
