class LockboxActionMailer < ApplicationMailer
  def add_cash_email
    @lockbox_partner = params[:lockbox_partner]
    @lockbox_action = params[:lockbox_action]
    email_addresses = @lockbox_partner.users.confirmed.pluck(:email)
    mail(to: email_addresses, subject: 'TODO add subject')
  end
end
