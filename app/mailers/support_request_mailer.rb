class SupportRequestMailer < ApplicationMailer
  def creation_alert
    @support_request = params[:support_request]

    email_addresses = @support_request.lockbox_partner.users.confirmed.pluck(:email)
    return if email_addresses.empty?

    subject = "A new Support Request was sent to #{@support_request.lockbox_partner.name}"

    mail(to: email_addresses, subject: subject, bcc: @support_request.user.email)
  end
end
