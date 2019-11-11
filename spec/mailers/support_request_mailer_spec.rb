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

  describe "#note_creation_alert" do
    let(:note) do
      FactoryBot.create(:note, user: admin_user, notable: support_request)
    end

    let(:email) do
      described_class.with(note: note).note_creation_alert.deliver_now
    end

    it "has the expected subject line" do
      expected_subject = "A new note was added to Support Request ##{support_request.id}"
      expect(email.subject).to eq(expected_subject)
    end

    context "when there are no confirmed partner users" do
      let(:lockbox_partner) { FactoryBot.create(:lockbox_partner) }

      it "raises an exception" do
        expect{email}.to raise_error(ArgumentError)
      end
    end

    context "when the note does not belong to a support request" do
      let(:support_request) { FactoryBot.create(:lockbox_action) }

      it "raises an exception" do
        expect{email}.to raise_error(ArgumentError)
      end
    end

    context "when an admin user creates the note" do
      it "sends the email to the lockbox partner's users" do
        expect(email.to).to eq(support_request.lockbox_partner.users.pluck(:email))
      end

      it "CCs the note creator and support request creator" do
        expect(email.cc).to eq([support_request.user.email, admin_user.email])
      end
    end

    context "when a partner user creates the note" do
      let(:note) do
        FactoryBot.create(
          :note, user: lockbox_partner.users.first, notable: support_request
        )
      end

      let(:email) do
        described_class.with(note: note).note_creation_alert.deliver_now
      end

      it "sends the email to the support request creator" do
        expect(email.to).to eq([support_request.user.email])
      end

      it "CCs the lockbox partner's users" do
        expect(email.cc).to eq(support_request.lockbox_partner.users.pluck(:email))
      end
    end

    context "body" do
      it "includes the support request ID" do
        expect(email.body.encoded).to include("##{support_request.id}")
      end

      it "includes a link to the support_request" do
        path = "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{support_request.id}"
        expect(email.body.encoded).to include(path)
      end
    end
  end

  describe "#status_update_alert" do
    let(:original_status) { "pending" }
    let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }
    let(:date) { Date.current }

    let(:user) do
      FactoryBot.create(:user, :partner_user, lockbox_partner: lockbox_partner)
    end

    let(:support_request) do
      FactoryBot.create(
        :support_request,
        :completed,
        lockbox_partner: lockbox_partner
      )
    end

    let(:email) do
      described_class
        .with(
          date: date,
          original_status: "pending",
          support_request: support_request,
          user: user
        )
        .status_update_alert
        .deliver_now
    end

    it "emails the support request creator" do
      expect(email.to).to eq([support_request.user.email])
    end

    it 'has the correct subject line' do
      expected_subject = "#{support_request.lockbox_partner.name} Support " \
                         "Request ##{support_request.id} - completed"
      expect(email.subject).to include(expected_subject)
    end

    it "has the correct body" do
      expected_body =
        "#{support_request.lockbox_partner.name} support request " \
        "##{support_request.id} was changed from pending to completed by " \
        "#{user.name} on #{date.strftime("%B %d, %Y")}."
      expect(email.body.encoded).to include(expected_body)
    end
  end
end
