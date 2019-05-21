require 'rails_helper'

describe LockboxPartner, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:lockbox_actions) }

  describe '#balance' do
    let(:lockbox) { FactoryBot.create(:lockbox_partner) }

    let(:start_date) { Date.current - 2.months }

    def add_cash(date)
      LockboxAction.create!(
        action_type:     'add_cash',
        status:          'pending',
        eff_date:        start_date,
        lockbox_partner: lockbox
      ).tap do |action|
        action.lockbox_transactions.create!(
          amount_cents: 1000_00,
          eff_date: start_date,
          balance_effect: 'credit'
        )
      end
    end

    def pending_request_on(date, amount_breakdown)
      lockbox.lockbox_actions.create!(
        action_type: 'client_support',
        status:      'pending',
        eff_date:    date,
      ).tap do |lb_action|
        amount_breakdown.each do |amt_cents|
          lb_action.lockbox_transactions.create!(
            eff_date: date,
            amount_cents: amt_cents,
            balance_effect: 'debit'
          )
        end
      end
    end

    context 'have only added cash but no support requests yet' do
      before { add_cash(start_date) }

      it 'returns the amount of the initial cashbox deposit' do
        expect(lockbox.balance).to eq(1000.to_money)
      end

      context 'excluding pending' do
        it 'returns 0' do
          expect(lockbox.balance(exclude_pending: true)).to eq(Money.zero)
        end

        context 'add cash was completed' do
          before { add_cash(start_date).complete! }

          it 'returns the 1000' do
            expect(lockbox.balance(exclude_pending: true)).to eq(1000.to_money)
          end
        end
      end
    end

    context 'add cash, multiple pending & completed actions' do
      before do
        add_cash(start_date).complete!
        pending_request_on(start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(start_date + 3.weeks, [100_00]).complete!
        pending_request_on(Date.current - 1.week, [30_00])
        pending_request_on(Date.current + 3.days, [45_00, 15_00, 10_00])
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
        add_cash(start_date).complete!
        pending_request_on(start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(start_date + 3.weeks, [100_00]).complete!
        pending_request_on(start_date + 4.weeks, [75_00, 20_00]).cancel!
        pending_request_on(Date.current - 2.weeks, [85_00, 10_00]).complete!
        pending_request_on(Date.current - 10.days, [100_00]).complete!
        pending_request_on(Date.current - 1.week, [30_00]).cancel!
        pending_request_on(Date.current + 3.days, [45_00, 15_00, 10_00])
        pending_request_on(Date.current + 5.days, [50_00, 15_00])
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
        add_cash(start_date).complete!
        pending_request_on(start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(start_date + 3.weeks, [100_00]).complete!
        pending_request_on(start_date + 4.weeks, [75_00, 20_00]).cancel!
        pending_request_on(Date.current - 2.weeks, [85_00, 10_00]).complete!
        pending_request_on(Date.current - 10.days, [100_00]).complete!
        pending_request_on(Date.current - 1.week, [30_00]).cancel!
        add_cash(Date.yesterday)
        pending_request_on(Date.current + 3.days, [45_00, 15_00, 10_00])
        pending_request_on(Date.current + 5.days, [50_00, 15_00])
      end

      it 'returns the correct balance -- $1435' do
        expect(lockbox.balance(exclude_pending: false)).to eq(1435.to_money)
      end

      context 'excluding pending transactions' do
        it 'returns the correct balance -- $570' do
          expect(lockbox.balance(exclude_pending: true)).to eq(570.to_money)
        end
      end
    end

    context 'With transactions on the current date' do
      before do
        add_cash(start_date).complete!
        pending_request_on(start_date + 1.week,  [20_00, 50_00]).complete!
        pending_request_on(start_date + 2.weeks, [30_00, 20_00, 15_00]).complete!
        pending_request_on(start_date + 3.weeks, [100_00]).complete!
        pending_request_on(start_date + 4.weeks, [75_00, 20_00]).cancel!
        pending_request_on(Date.current - 2.weeks, [85_00, 10_00]).complete!
        pending_request_on(Date.current - 10.days, [100_00]).complete!
        pending_request_on(Date.current - 1.week, [30_00]).cancel!
        add_cash(Date.yesterday)
        pending_request_on(Date.current, [10_00, 30_00])
        pending_request_on(Date.current, [35_00, 45_00]).complete!
        pending_request_on(Date.current, [70_00, 50_00, 30_00]).cancel!
        pending_request_on(Date.current + 3.days, [45_00, 15_00, 10_00])
        pending_request_on(Date.current + 5.days, [50_00, 15_00])
      end

      it 'returns the correct balance -- $1315' do
        expect(lockbox.balance(exclude_pending: false)).to eq(1315.to_money)
      end

      context 'excluding pending transactions' do
        it 'returns the correct balance -- $490' do
          expect(lockbox.balance(exclude_pending: true)).to eq(490.to_money)
        end
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
      let!(:older_lb_action) { FactoryBot.create(:lockbox_action, lockbox_partner: lockbox_partner_1, eff_date: Date.yesterday) }
      let!(:newer_lb_action) { FactoryBot.create(:lockbox_action, lockbox_partner: lockbox_partner_1, eff_date: Date.today) }
      let!(:action_for_diff_partner) { FactoryBot.create(:lockbox_action, lockbox_partner: lockbox_partner_2, eff_date: Date.today) }

      it 'returns an array of lockbox transactions in reverse chronological order' do
        expect(lockbox_partner_1.historical_actions).to match([newer_lb_action, older_lb_action])
      end
    end    
  end

end