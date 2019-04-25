require 'rails_helper'

describe LockboxAction, type: :model do
  it { is_expected.to belong_to(:lockbox_partner) }
  it { is_expected.to have_many(:lockbox_transactions) }
  it { is_expected.to have_many(:notes) }

  describe '#amount' do
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

    context 'when no transactions are present' do
      before do
        subject.lockbox_transactions.each(&:destroy)
        subject.reload
      end

      it "return zero" do
        expect(subject.amount).to eq(Money.zero)
      end
    end

    context 'when action is in canceled status' do
      before do
        subject.cancel!
      end

      it "returns zero" do
        expect(subject.amount).to eq(Money.zero)
      end
    end
  end

  describe '#cancel!' do
    subject { FactoryBot.create(:lockbox_action) }

    it 'updates the status to canceled' do
      expect { subject.cancel! }.to change{ subject.status }.from('pending').to('canceled')
    end
  end

  describe '#complete!' do
    subject { FactoryBot.create(:lockbox_action) }

    it 'updates the status to canceled' do
      expect { subject.complete! }.to change{ subject.status }.from('pending').to('completed')
    end
  end
end