class SupportRequestMailer < ApplicationMailer
  def creation_alert
    @support_request = params[:support_request]

    return if partner_user_emails.empty?

    urgency_flag_prefix = if @support_request.urgency_flag.present?
      "#{@support_request.urgency_flag} - "
    else
      ""
    end

    subject = "#{urgency_flag_prefix}MAC Cash Box Withdrawal Request"

    mail(
      to: partner_user_emails,
      subject: subject,
      cc: @support_request.user.email
    )
  end

  def note_creation_alert
    @note = params[:note]
    @support_request = @note.notable

    unless @support_request.is_a?(SupportRequest)
      raise ArgumentError, "This note is not associated with a support request"
    end

    return if partner_user_emails.empty?
    subject = "A new note was added to Support Request ##{@support_request.id}"
    coordinator_emails = [@support_request.user.email, @note.user.email].uniq
    mail(
      to: partner_user_emails,
      subject: subject,
      cc: coordinator_emails
    )
  end

  private

  def partner_user_emails
    @partner_user_emails ||= @support_request
      .lockbox_partner
      .users
      .confirmed
      .pluck(:email)
  end
end
