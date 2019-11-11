class SupportRequestMailer < ApplicationMailer
  def creation_alert
    @support_request = params[:support_request]
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

    subject = "A new note was added to Support Request ##{@support_request.id}"
    coordinator_emails = [@support_request.user.email]
    # If a coordinator creates the note, email the partner users and CC the
    # coordinator(s). If a partner user creates it, do the reverse
    to_emails, cc_emails = if @note.user.admin?
      coordinator_emails << @note.user.email
      [partner_user_emails, coordinator_emails.uniq]
    else
      [coordinator_emails, partner_user_emails]
    end

    mail(to: to_emails, subject: subject, cc: cc_emails)
  end

  def status_update_alert
    @support_request = params[:support_request]
    @user = params[:user]
    @original_status = params[:original_status]
    @date = params[:date].strftime("%B %d, %Y")
    subject = "#{@support_request.lockbox_partner.name} Support Request " \
              "##{@support_request.id} - #{@support_request.status}"
    mail(
      to: @support_request.user.email,
      subject: subject
    )
  end

  private

  def partner_user_emails
    @partner_user_emails ||= @support_request
      .lockbox_partner
      .users
      .confirmed
      .pluck(:email)
    if @partner_user_emails.empty?
      raise ArgumentError, "Attempted to alert users for "\
        "#{@support_request.lockbox_partner.name}, but none exist"
    end
    @partner_user_emails
  end
end
