require 'rails_helper'
require './lib/create_support_request'

describe SupportRequest, type: :model do
  it { is_expected.to belong_to(:lockbox_partner) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:lockbox_action) }
  it { is_expected.to have_many(:notes) }

  it { is_expected.to validate_presence_of(:name_or_alias) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:lockbox_partner) }

  describe 'status scopes' do
    let!(:pending_request) { FactoryBot.create(:support_request, :pending) }
    let!(:completed_request) { FactoryBot.create(:support_request, :completed) }
    let!(:canceled_request) { FactoryBot.create(:support_request, :canceled) }

    it 'returns only pending support requests' do
      results = SupportRequest.pending

      expect(results).to     include(pending_request)
      expect(results).not_to include(completed_request)
      expect(results).not_to include(canceled_request)
    end

    it 'returns only completed support requests' do
      results = SupportRequest.completed

      expect(results).not_to include(pending_request)
      expect(results).to     include(completed_request)
      expect(results).not_to include(canceled_request)
    end

    it 'returns only canceled support requests' do
      results = SupportRequest.canceled

      expect(results).not_to include(pending_request)
      expect(results).not_to include(completed_request)
      expect(results).to     include(canceled_request)
    end
  end

  describe 'partner status scopes' do
    let!(:pending_wrong_partner) { FactoryBot.create(:support_request, :pending) }
    let!(:completed_wrong_partner) { FactoryBot.create(:support_request, :completed) }
    let!(:canceled_wrong_partner) { FactoryBot.create(:support_request, :canceled) }
    let!(:pending_right_partner) { FactoryBot.create(:support_request, :pending) }
    let!(:completed_right_partner) { FactoryBot.create(:support_request, :completed) }
    let!(:canceled_right_partner) { FactoryBot.create(:support_request, :canceled) }

    let(:right_partner) { FactoryBot.create(:lockbox_partner) }
    let(:wrong_partner) { FactoryBot.create(:lockbox_partner) }

    before do
      pending_wrong_partner.update(lockbox_partner: wrong_partner)
      completed_wrong_partner.update(lockbox_partner: wrong_partner)
      canceled_wrong_partner.update(lockbox_partner: wrong_partner)

      pending_right_partner.update(lockbox_partner: right_partner)
      completed_right_partner.update(lockbox_partner: right_partner)
      canceled_right_partner.update(lockbox_partner: right_partner)
    end

    it 'returns only pending support requests' do
      results = SupportRequest.pending_for_partner(lockbox_partner_id: right_partner.id)

      expect(results).to     include(pending_right_partner)
      expect(results).not_to include(completed_right_partner)
      expect(results).not_to include(canceled_right_partner)

      expect(results).not_to include(pending_wrong_partner)
      expect(results).not_to include(completed_wrong_partner)
      expect(results).not_to include(canceled_wrong_partner)
    end

    it 'returns only completed support requests' do
      results = SupportRequest.completed_for_partner(lockbox_partner_id: right_partner.id)

      expect(results).not_to include(pending_right_partner)
      expect(results).to     include(completed_right_partner)
      expect(results).not_to include(canceled_right_partner)

      expect(results).not_to include(pending_wrong_partner)
      expect(results).not_to include(completed_wrong_partner)
      expect(results).not_to include(canceled_wrong_partner)
    end

    it 'returns only canceled support requests' do
      results = SupportRequest.canceled_for_partner(lockbox_partner_id: right_partner.id)

      expect(results).not_to include(pending_right_partner)
      expect(results).not_to include(completed_right_partner)
      expect(results).to     include(canceled_right_partner)

      expect(results).not_to include(pending_wrong_partner)
      expect(results).not_to include(completed_wrong_partner)
      expect(results).not_to include(canceled_wrong_partner)
    end
  end

  describe '#send_status_update_alert' do
    let(:original_status) { 'pending' }
    let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }

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

    let(:delivery) do
      instance_double(
        ActionMailer::Parameterized::MessageDelivery,
        deliver_now: nil
      )
    end

    let(:mailer) { double(status_update_alert: delivery) }

    before do
      allow(SupportRequestMailer).to receive(:with).and_return(mailer)
      support_request.send_status_update_alert(
        original_status: original_status,
        user: user
      )
    end

    context 'when the new status is different from the original status' do
      it 'passes the correct params to the mailer' do
        expect(SupportRequestMailer)
          .to have_received(:with)
          .with(
            date: Date.current,
            original_status: original_status,
            support_request: support_request,
            user: user
          )
      end

      it 'sends the email' do
        expect(delivery).to have_received(:deliver_now)
      end
    end

    context 'when the new status is the same as the original status' do
      let(:original_status) { 'completed' }

      it 'does nothing' do
        expect(SupportRequestMailer).not_to have_received(:with)
      end
    end
  end

  describe "creating notes on update" do
    let(:support_request) { FactoryBot.create(:support_request, :pending) }

    it 'adds a note for name/alias change' do
      expect{ support_request.update(name_or_alias: "name change") }.to change{support_request.notes.count}.by(1)
      expect(support_request.notes.last.text).to include("The Client Alias for this Support Request was changed")
    end

    it 'adds a note for client_ref_ID change' do
      expect{ support_request.update(client_ref_id: "refID change") }.to change{support_request.notes.count}.by(1)
      expect(support_request.notes.last.text).to include("The Client Reference ID for this Support Request was changed")
    end

    it 'adds a note for urgency_flag change' do
      expect{ support_request.update(urgency_flag: "urgency change") }.to change{support_request.notes.count}.by(1)
      expect(support_request.notes.last.text).to include("The Urgency Flag for this Support Request was changed")
    end

    it 'adds a note for eff_date change' do
      expect{
        support_request.update(lockbox_action_attributes: {id: support_request.lockbox_action.id, eff_date: 1.day.from_now}) }.to change{support_request.notes.count}.by(1)
      expect(support_request.notes.last.text).to include("The Pickup Date for this Support Request was changed")
    end

    it 'adds a note when a new transaction is added' do
      expect{
        support_request.update(lockbox_action_attributes: {id: support_request.lockbox_action.id, lockbox_transactions_attributes: [{amount: 10.32, category: 'Gas'}]}) }.to change{support_request.notes.count}.by(1)
      expect(support_request.notes.last.text).to include("The Total Amount for this Support Request was changed")
      expect(support_request.notes.last.text).to include("$10.32")
    end

    it 'makes multiple notes for multiple changes' do
      expect{
        support_request.update(
          name_or_alias: "name change 2",
          urgency_flag: "urgency change 2"
        )
      }.to change{support_request.notes.count}.by(2)
    end

  end
end
