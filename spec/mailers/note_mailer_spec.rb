require 'rails_helper'

describe NoteMailer, type: :mailer do
  let!(:admin_user) { FactoryBot.create(:user) }
  let!(:admin_user2) { FactoryBot.create(:user) }
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }

  let(:support_request) do
    FactoryBot.create(
      :support_request, :pending, lockbox_partner: lockbox_partner
    )
  end

  describe "#note_creation_alert" do
    let(:note) do
      FactoryBot.create(:note, user: admin_user, notable: support_request)
    end
    let(:system_note) do
      FactoryBot.create(:note, user: nil, notable: support_request)
    end

    let(:email) do
      described_class.with(note: note).note_creation_alert.deliver_now
    end

    describe "content" do
      it "has the expected subject line" do
        expected_subject = "New note from #{note.author} on Support Request ##{note.notable_id}"
        expect(email.subject).to eq(expected_subject)
      end

      it "includes the support request ID" do
        expect(email.body.encoded).to include("##{note.notable_id}")
      end

      it "includes a link to the support_request" do
        path = "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{note.notable_id}"
        expect(email.body.encoded).to include(path)
      end
    end

    context "for a system note" do
      let(:email) do
        described_class.with(note: system_note).note_creation_alert.deliver_now
      end

      it "has the expected subject line" do
        expected_subject = "New System note on Support Request ##{note.notable_id}"
        expect(email.subject).to eq(expected_subject)
      end
    end

    context "when an admin user creates the note" do
      it "emails the lockbox partner's users" do
        note.notable.lockbox_partner.users.pluck(:email).compact.each do |address|
          expect(email.to).to include(address)
        end
      end

      it "emails the other admins" do
        expect(User.admin.count).to eq(2) # need to make sure we're emailing OTHER admins
        (User.admin.pluck(:email) - [note.user.email]).compact.each do |address|
          expect(email.to).to include(address)
        end
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

      it "emails the lockbox partner's users" do
        note.notable.lockbox_partner.users.pluck(:email).compact.each do |address|
          expect(email.to).to include(address)
        end
      end

      it "emails all the admins" do
        expect(User.admin.count).to eq(2) # need to make sure we're emailing OTHER admins
        User.admin.pluck(:email).compact.each do |address|
          expect(email.to).to include(address)
        end
      end
    end
  end
end
