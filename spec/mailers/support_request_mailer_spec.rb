require 'rails_helper'

describe SupportRequestMailer, type: :mailer do
  let(:admin_user) { FactoryBot.create(:user) }
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }

  let(:support_request) do
    FactoryBot.create(
      :support_request, :pending, lockbox_partner: lockbox_partner
    )
  end

  describe "#creation_alert" do
    let(:email) do
      described_class
        .with(support_request: support_request)
        .creation_alert
        .deliver_now
    end

    context "when there is no urgency flag" do
      it "has the expected subject line" do
        expect(email.subject).to eq("MAC Cash Box Withdrawal Request")
      end
    end

    context "when there is an urgency flag" do
      let(:support_request) do
        FactoryBot.create(
          :support_request,
          :pending,
          lockbox_partner: lockbox_partner,
          urgency_flag: "Super Urgent"
        )
      end

      it "has the expected subject line" do
        expect(email.subject).to eq(
          "Super Urgent - MAC Cash Box Withdrawal Request"
        )
      end
    end

    it "sends the email to the lockbox partner's confirmed users" do
      expect(email.to).to eq(support_request.lockbox_partner.users.pluck(:email))
    end

    it "CCs the admin user who created the support request" do
      expect(email.cc).to eq([support_request.user.email])
    end

    context "body" do
      it "includes the pickup date" do
        expect(email.body.encoded).to include(
          support_request.pickup_date.strftime("%A, %B %d, %Y")
        )
      end

      it "includes the amount" do
        expect(email.body.encoded).to include(support_request.amount.format)
      end

      it "includes the coordinator's name" do
        expected_name = ERB::Util.html_escape(support_request.user.name)
        expect(email.body.encoded).to include(expected_name)
      end

      it "includes a link to the support_request" do
        path = "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{support_request.id}"
        expect(email.body.encoded).to include(path)
      end
    end

    context "when there are no confirmed partner users" do
      let(:lockbox_partner) { FactoryBot.create(:lockbox_partner) }

      it "raises an exception" do
        expect{email}.to raise_error(ArgumentError)
      end
    end
  end
end
