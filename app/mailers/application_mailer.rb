class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['REPLY_TO_EMAIL']}", reply_to: "#{ENV['LOCKBOX_EMAIL']}"
  layout 'mailer'
end
