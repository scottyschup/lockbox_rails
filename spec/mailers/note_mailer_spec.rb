require 'rails_helper'

describe NoteMailer, type: :mailer do
  let!(:admin_user) { FactoryBot.create(:user) }
  let!(:admin_user2) { FactoryBot.create(:user) }
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }
  let(:support_request) do
    FactoryBot.create(:support_request, :pending, lockbox_partner: lockbox_partner)
  end

  let(:admin_note) do
    FactoryBot.create(:note, user: admin_user, notable: support_request)
  end
  let(:system_note) do
    FactoryBot.create(:note, user: nil, notable: support_request)
  end
  let(:partner_note) do
    FactoryBot.create(:note, user: lockbox_partner.users.first, notable: support_request)
  end

  describe "#note_creation_alert" do
    describe "content" do
      it "has the expected subject line" do
        admin_note
        email = ActionMailer::Base.deliveries.first
        expected_subject = "New note from #{admin_note.author} on Support Request ##{admin_note.notable_id}"
        expect(email.subject).to eq(expected_subject)
      end

      it "includes a link to the support_request" do
        admin_note
        email = ActionMailer::Base.deliveries.first
        path = "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{admin_note.notable_id}"
        expect(email.body.encoded).to include(path)
      end
    end

    context "for a system note" do
      it "has the expected subject line" do
        system_note
        email = ActionMailer::Base.deliveries.first
        expected_subject = "New System note on Support Request ##{system_note.notable_id}"
        expect(email.subject).to eq(expected_subject)
      end
    end

    context "when an admin user creates the note" do
      it "emails the lockbox partner's users" do
        admin_note.notable.lockbox_partner.users.pluck(:email).compact.each do |address|
          expect(recipients).to include(address)
        end
      end

      it "emails the other admins" do
        expect(User.admin.count).to be > 1 # need to make sure we're emailing OTHER admins
        (User.admin.pluck(:email) - [admin_note.user.email]).compact.each do |address|
          expect(recipients).to include(address)
        end
      end
    end

    context "when a partner user creates the note" do
      it "emails the lockbox partner's users" do
        partner_note.notable.lockbox_partner.users.pluck(:email).compact.each do |address|
          expect(recipients).to include(address)
        end
      end

      it "emails all the admins" do
        partner_note
        expect(User.admin.count).to be > 1 # need to make sure we're emailing OTHER admins
        User.admin.pluck(:email).compact.each do |address|
          expect(recipients).to include(address)
        end
      end
    end
  end

  def recipients
    ActionMailer::Base.deliveries.collect(&:to).flatten
  end
end
