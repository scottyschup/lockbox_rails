require 'rails_helper'

describe LockboxAction, type: :model do
  it { is_expected.to belong_to(:lockbox_partner) }
  it { is_expected.to have_many(:lockbox_transactions) }
  it { is_expected.to have_many(:notes) }

  describe 'amount' do
    subject do
      FactoryBot.create(:lockbox_action, :support_client).tap do |action|
        action.lockbox_transactions.create(
          amount_cents: 20_00,
          category: 'gas'
        )
        action.lockbox_transactions.create(
          amount_cents: 20_00,
          category: 'medicine'
        )
      end
    end

    it "sums the action's transactions" do
      expect(subject.amount).to eq(40.to_money)
    end

    xcontext 'when no transactions are present' do
      # Is this even a valid use case?
      # I think the only context in which this would
      # makes sense is reconciliation where the amount
      # expected vs the amount counted

      it "return zero" do

      end
    end

    xcontext 'when action is in canceled status' do
      # Does it make sense to return zero no matter
      # what if it's in canceled status?
    end
  end
end