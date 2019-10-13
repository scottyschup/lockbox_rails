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

  describe "#creator" do
    subject { SupportRequest.new }

    let(:user) { instance_double(User) }

    let(:record_trail) do
      instance_double(PaperTrail::RecordTrail, originator: originator)
    end

    before do
      allow(subject).to receive(:paper_trail).and_return(record_trail)
      allow(User).to receive(:find).and_return(user)
    end

    context "when the originator is nil" do
      let(:originator) { nil }

      it "returns nil" do
        expect(subject.creator).to be_nil
      end
    end

    context "when the originator is not nil" do
      let(:originator) { "1" }

      it "returns the user who created the request" do
        expect(subject.creator).to eq(user)
      end
    end
  end
end
