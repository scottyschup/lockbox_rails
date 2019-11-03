require 'rails_helper'

describe SupportRequestMailer, type: :model do
  describe "#note_creation_alert" do
    let(:admin_user) { FactoryBot.create(:user) }
    let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }

    let(:support_request) do
      FactoryBot.create(
        :support_request, :pending, lockbox_partner: lockbox_partner
      )
    end

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
  end
end
