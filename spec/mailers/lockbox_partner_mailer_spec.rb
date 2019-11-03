require 'rails_helper'

describe LockboxPartnerMailer, type: :mailer do
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }

  describe "#low_balance_alert" do
    let(:low_balance_alert_email) { "lowbalancealert@example.com" }

    let(:email) do
      described_class
        .with(lockbox_partner: lockbox_partner)
        .low_balance_alert
        .deliver_now
    end

    before do
      allow(ENV)
        .to receive(:[])
        .with("LOW_BALANCE_ALERT_EMAIL")
        .and_return(low_balance_alert_email)
    end

    it "sends the email to the address specified in an env var" do
      expect(email.to).to eq([low_balance_alert_email])
    end

    it "has the expected subject line" do
      expect(email.subject).to eq(
        "[LOW LOCKBOX BALANCE] #{lockbox_partner.name} needs cash"
      )
    end
  end
end
