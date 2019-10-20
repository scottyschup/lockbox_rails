class SupportRequestMailer < ApplicationMailer
  def creation_alert
    @support_request = params[:support_request]

    email_addresses = @support_request.lockbox_partner.users.confirmed.pluck(:email)
    return if email_addresses.empty?

    urgency_flag_prefix = if @support_request.urgency_flag.present?
      "#{@support_request.urgency_flag} - "
    else
      ""
    end

    subject = "#{urgency_flag_prefix}MAC Cash Box Withdrawal Request"

    mail(to: email_addresses, subject: subject, cc: @support_request.user.email)
  end
end
