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

  describe '.pending_for_lockbox' do
    def create_support_requests(partner, n)
      [].tap do |arr|
        n.times do
          req = CreateSupportRequest.call!(
            params: {
              lockbox_partner_id: partner.id,
              name_or_alias: Faker::Name.name,
              user_id: user.id,
              client_ref_id: 'somestring',
              lockbox_action: {
                eff_date: Date.current,
                lockbox_transactions: [
                  {
                    amount: Money.new(12345),
                    category: LockboxTransaction::EXPENSE_CATEGORIES.sample
                  }
                ]
              }
            }
          )

          arr << req
        end
      end
    end

    let(:user)              { FactoryBot.create(:user) }
    let(:lockbox_partner_1) { FactoryBot.create(:lockbox_partner, :active) }
    let(:lockbox_partner_2) { FactoryBot.create(:lockbox_partner, :active) }

    let(:correct_partner_wrong_status) do
      create_support_requests(lockbox_partner_1, 2).tap do |support_reqs|
        support_reqs.first.lockbox_action.complete!
        support_reqs.last.lockbox_action.cancel!
      end
    end

    let(:wrong_partner_correct_status) do
      create_support_requests(lockbox_partner_2, 1)
    end

    let!(:expected_returned) do
      create_support_requests(lockbox_partner_1, 2)
    end

    let!(:not_expected_returned) do
      correct_partner_wrong_status + wrong_partner_correct_status
    end

    it "returns only pending status support_requests for a given partner" do
      result = described_class.pending_for_partner(lockbox_partner_id: lockbox_partner_1.id)
      expect(result).to match(expected_returned)
    end
  end
end
