require 'rails_helper'
require './lib/add_cash_to_lockbox'

describe LockboxPartner, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:lockbox_actions) }

  def add_cash(partner, date)
    LockboxAction.create!(
      action_type:     'add_cash',
      status:          'pending',
      eff_date:        date,
      lockbox_partner: partner
    ).tap do |action|
      action.lockbox_transactions.create!(
        amount_cents: 1000_00,
        balance_effect: 'credit',
        category: LockboxTransaction::GAS
      )
    end
  end

  def pending_request_on(partner, date, amount_breakdown)
    partner.lockbox_actions.create!(
      action_type: 'client_support',
      status:      'pending',
      eff_date:    date,
    ).tap do |lb_action|
      amount_breakdown.each do |amt_cents|
        lb_action.lockbox_transactions.create!(
          amount_cents: amt_cents,
          balance_effect: 'debit',
          category: LockboxTransaction::GAS
        )
      end
    end
  end

  describe '#cash_addition_confirmation_pending?' do
    it "is true if the partner has a pending cash addition" do
      lp = FactoryBot.create(:lockbox_partner)
      expect(lp).not_to be_cash_addition_confirmation_pending

      AddCashToLockbox.call(lockbox_partner: lp, eff_date: Date.today, amount: 100)

      expect(lp).to be_cash_addition_confirmation_pending

      lp.lockbox_actions.pending_cash_additions.each do |la|
        la.complete!
      end

      expect(lp).not_to be_cash_addition_confirmation_pending
    end
  end

  describe '#balance' do
    let(:lockbox)    { FactoryBot.create(:lockbox_partner) }
    let(:start_date) { Date.current - 2.months }

    context 'have only added cash but no support requests yet' do
      let(:add_cash_action) { add_cash(lockbox, start_date) }

      context 'when the add cash is pending' do
        it 'returns 0' do
          expect(lockbox.balance).to eq(Money.zero)
          expect(lockbox.balance(exclude_pending: true)).to eq(Money.zero)
        end
      end

      context 'when the add cash action is completed' do
        before { add_cash_action.complete! }

        it 'returns the amount of the initial cashbox deposit' do
          expect(lockbox.balance).to eq(1000.to_money)
          expect(lockbox.balance(exclude_pending: true)).to eq(1000.to_money)
        end
      end
    end

    context 'add cash, multiple pending & completed actions' do
      before do
        add_cash(lockbox, start_date).complete!
        pending_request_on(lockbox, start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(lockbox, start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(lockbox, start_date + 3.weeks, [100_00]).complete!
        pending_request_on(lockbox, Date.current - 1.week, [30_00])
        pending_request_on(lockbox, Date.current + 3.days, [45_00, 15_00, 10_00])
      end

      it 'returns the correct balance -- $665' do
        expect(lockbox.balance(exclude_pending: false)).to eq(665.to_money)
      end

      context 'excluding pending transactions' do
        it 'returns the correct balance -- $765' do
          expect(lockbox.balance(exclude_pending: true)).to eq(765.to_money)
        end
      end
    end

    context 'add cash, multiple pending, completed, and canceled actions' do
      before do
        add_cash(lockbox, start_date).complete!
        pending_request_on(lockbox, start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(lockbox, start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(lockbox, start_date + 3.weeks, [100_00]).complete!
        pending_request_on(lockbox, start_date + 4.weeks, [75_00, 20_00]).cancel!
        pending_request_on(lockbox, Date.current - 2.weeks, [85_00, 10_00]).complete!
        pending_request_on(lockbox, Date.current - 10.days, [100_00]).complete!
        pending_request_on(lockbox, Date.current - 1.week, [30_00]).cancel!
        pending_request_on(lockbox, Date.current + 3.days, [45_00, 15_00, 10_00])
        pending_request_on(lockbox, Date.current + 5.days, [50_00, 15_00])
      end

      it 'returns the correct balance -- $435' do
        expect(lockbox.balance(exclude_pending: false)).to eq(435.to_money)
      end

      context 'excluding pending transactions' do
        it 'returns the correct balance -- $570' do
          expect(lockbox.balance(exclude_pending: true)).to eq(570.to_money)
        end
      end
    end

    context 'multiple add cash events and a variety of transactions' do
      before do
        add_cash(lockbox, start_date).complete!
        pending_request_on(lockbox, start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(lockbox, start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(lockbox, start_date + 3.weeks, [100_00]).complete!
        pending_request_on(lockbox, start_date + 4.weeks, [75_00, 20_00]).cancel!
        pending_request_on(lockbox, Date.current - 2.weeks, [85_00, 10_00]).complete!
        pending_request_on(lockbox, Date.current - 10.days, [100_00]).complete!
        pending_request_on(lockbox, Date.current - 1.week, [30_00]).cancel!
        add_cash(lockbox, Date.yesterday).complete!
        pending_request_on(lockbox, Date.current + 3.days, [45_00, 15_00, 10_00])
        pending_request_on(lockbox, Date.current + 5.days, [50_00, 15_00])
      end

      it 'returns the correct balance -- $1435' do
        expect(lockbox.balance(exclude_pending: false)).to eq(1435.to_money)
      end

      context 'excluding pending transactions' do
        it 'returns the correct balance -- $1570' do
          expect(lockbox.balance(exclude_pending: true)).to eq(1570.to_money)
        end
      end
    end

    context 'With transactions on the current date' do
      before do
        add_cash(lockbox, start_date).complete!
        pending_request_on(lockbox, start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(lockbox, start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(lockbox, start_date + 3.weeks, [100_00]).complete!
        pending_request_on(lockbox, start_date + 4.weeks, [75_00, 20_00]).cancel!
        pending_request_on(lockbox, Date.current - 2.weeks, [85_00, 10_00]).complete!
        pending_request_on(lockbox, Date.current - 10.days, [100_00]).complete!
        pending_request_on(lockbox, Date.current - 1.week, [30_00]).cancel!
        add_cash(lockbox, Date.yesterday)
        pending_request_on(lockbox, Date.current, [10_00, 30_00])
        pending_request_on(lockbox, Date.current, [35_00, 45_00]).complete!
        pending_request_on(lockbox, Date.current, [70_00, 50_00, 30_00]).cancel!
        pending_request_on(lockbox, Date.current + 3.days, [45_00, 15_00, 10_00])
        pending_request_on(lockbox, Date.current + 5.days, [50_00, 15_00])
      end

      it 'returns the correct balance -- $1315' do
        expect(lockbox.balance(exclude_pending: false)).to eq(315.to_money)
      end

      context 'excluding pending transactions' do
        it 'returns the correct balance -- $490' do
          expect(lockbox.balance(exclude_pending: true)).to eq(490.to_money)
        end
      end
    end
  end

  describe '#relevant_transactions_for_balance' do
    let(:partner_1) { FactoryBot.create(:lockbox_partner) }
    let(:partner_2) { FactoryBot.create(:lockbox_partner) }

    let!(:pending_add_cash)                { add_cash(partner_1, Date.yesterday) }
    let!(:completed_add_cash)              { add_cash(partner_1, Date.yesterday).tap{|a| a.complete!} }
    let!(:diff_partner_completed_add_cash) { add_cash(partner_2, Date.yesterday).tap{|a| a.complete!} }

    let!(:canceled_support)                { pending_request_on(partner_1, Date.yesterday, [10_00]).tap{|a| a.cancel!} }
    let!(:pending_support)                 { pending_request_on(partner_1, Date.yesterday, [10_00]) }
    let!(:diff_partner_pending_support)    { pending_request_on(partner_2, Date.yesterday, [10_00]) }
    let!(:completed_support)               { pending_request_on(partner_1, Date.yesterday, [10_00]).tap{|a| a.complete!} }
    let!(:diff_partner_completed_support)  { pending_request_on(partner_2, Date.yesterday, [10_00]).tap{|a| a.complete!} }

    it 'returns pending and completed transactions for that lockbox partner' do
      expected_results = [
        completed_add_cash.lockbox_transactions,
        pending_support.lockbox_transactions,
        completed_support.lockbox_transactions
      ].flatten
      expect(partner_1.relevant_transactions_for_balance).to match(expected_results)
    end

    context 'when exclude_pending: true' do
      it 'returns only completed transactions for that lockbox partner' do
        expected_results = [
          completed_add_cash.lockbox_transactions,
          completed_support.lockbox_transactions
        ].flatten
        expect(partner_1.relevant_transactions_for_balance(exclude_pending: true)).to match(expected_results)
      end
    end
  end

  describe '#historical_actions' do
    let(:lockbox_partner_1) { FactoryBot.create(:lockbox_partner) }
    let(:lockbox_partner_2) { FactoryBot.create(:lockbox_partner) }

    context 'when no actions are present for that lockbox partner' do
      it 'returns an empty array' do
        expect(lockbox_partner_1.historical_actions).to eq([])
      end
    end

    context 'when actions are present for that lockbox partner' do
      let!(:older_lb_action) { FactoryBot.create(:lockbox_action, lockbox_partner: lockbox_partner_1, eff_date: Date.today-1.day) }
      let!(:newer_lb_action) { FactoryBot.create(:lockbox_action, lockbox_partner: lockbox_partner_1, eff_date: Date.today) }
      let!(:action_for_diff_partner) { FactoryBot.create(:lockbox_action, lockbox_partner: lockbox_partner_2, eff_date: Date.today) }

      it 'returns an array of lockbox transactions in reverse chronological order' do
        expect(lockbox_partner_1.historical_actions).to match([newer_lb_action, older_lb_action])
      end
    end
  end

  describe '#active?' do
    let(:lockbox_partner) { FactoryBot.create(:lockbox_partner) }

    before do
      allow(lockbox_partner.users).to receive_message_chain(:confirmed, :exists?)
                                  .and_return(confirmed_user_exists)
    end

    subject { lockbox_partner.active? }

    context 'when no confirmed user exists' do
      let(:confirmed_user_exists) { false }

      it { is_expected.to be false }
    end

    context 'when a confirmed user exists' do
      let(:confirmed_user_exists) { true }

      before do
        allow(lockbox_partner.lockbox_actions)
          .to receive_message_chain(:completed_cash_additions, :exists?)
          .and_return(completed_cash_addition_exists)
      end

      context 'when a completed cash addition does not exist' do
        let(:completed_cash_addition_exists) { false }

        it { is_expected.to be false }
      end

      context 'when a completed cash addition exists' do
        let(:completed_cash_addition_exists) { true }

        it { is_expected.to be true }
      end
    end
  end

  describe '#reconciliation_needed?' do
    subject { lockbox_partner.reconciliation_needed? }

    context 'when the lockbox has been reconciled before' do
      let(:lockbox_partner) { create(:lockbox_partner, :active) }

      let!(:reconciliation_action) do
        create(
          :lockbox_action,
          :reconciliation,
          lockbox_partner: lockbox_partner,
          eff_date: reconciliation_date
        )
      end

      context 'when the lockbox was last reconciled within the reconciliation interval' do
        let(:reconciliation_date) do
          (LockboxPartner::RECONCILIATION_INTERVAL - 1).days.ago
        end

        it { is_expected.to be false }
      end

      context 'when the lockbox was last reconciled outside the reconciliation interval' do
        let(:reconciliation_date) do
          LockboxPartner::RECONCILIATION_INTERVAL.days.ago
        end

        it { is_expected.to be true }
      end
    end

    context 'when the lockbox has not been reconciled before' do
      let(:lockbox_partner) do
        create(:lockbox_partner, :active)
      end

      context 'when there is a completed cash addition' do
        let!(:add_cash_action) do
          create(
            :lockbox_action,
            :add_cash,
            :completed,
            lockbox_partner: lockbox_partner,
            eff_date: add_cash_date
          )
        end

        context 'when the initial cash addition was within the reconciliation interval' do
          let(:add_cash_date) { (LockboxPartner::RECONCILIATION_INTERVAL - 1).days.ago }

          it { is_expected.to be false }
        end

        context 'when the initial cash addition was outside the reconciliation interval' do
          let(:add_cash_date) { LockboxPartner::RECONCILIATION_INTERVAL.days.ago }

          it { is_expected.to be true }
        end
      end

      context 'when there is no completed cash addition' do
        it { is_expected.to be false }
      end
    end

    context 'when the lockbox has not been saved' do
      let(:lockbox_partner) { build(:lockbox_partner) }

      it { is_expected.to be false }
    end
  end

  describe 'low_balance?' do
    it 'is true when the balance is below $300' do
      lockbox_partner = FactoryBot.create(:lockbox_partner)

      low_amount = LockboxPartner::MINIMUM_ACCEPTABLE_BALANCE - Money.new(100)
      AddCashToLockbox.call!(lockbox_partner: lockbox_partner, eff_date: 1.day.ago, amount: low_amount).complete!
      expect(lockbox_partner).to be_low_balance

      AddCashToLockbox.call!(lockbox_partner: lockbox_partner, eff_date: 1.day.ago, amount: Money.new(100)).complete!
      expect(lockbox_partner).not_to be_low_balance
    end
  end
end
