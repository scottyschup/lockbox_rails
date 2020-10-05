require 'rails_helper'
require './lib/reconciliation'

describe Reconciliation do
  let!(:lockbox_partner) { create(:lockbox_partner, :active) }
  let(:amount) { Monetize.parse('1100.00') }

  before do
    ENV['LOCKBOX_EMAIL'] = 'foo@bar.com'
    ENV['FINANCE_EMAIL'] = 'fizz@buzz.com'
  end

  def reconcile
    Reconciliation.call(lockbox_partner: lockbox_partner, amount: amount)
  end

  context 'when the amount is invalid' do
    let(:amount) { 'not an amount' }

    it 'does not create a lockbox action' do
      expect{reconcile}.not_to change(LockboxAction, :count)
    end

    it 'fails' do
      expect(reconcile.succeeded?).to be false
    end

    it 'does not send out an email' do
      reconcile
      expect  { ReconciliationCompletedMailerWorker.drain }
        .not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  context 'the lockbox action is invalid' do
    before do
      allow_any_instance_of(LockboxAction).to receive(:valid?).and_return(false)
    end

    it 'does return an error message to caller' do
      response = reconcile
      expect(response.outcome).to be :error
      expect(response.failure).to match(/Lockbox action not created: /)
    end

    it 'does not send out an email' do
      reconcile
      expect  { ReconciliationCompletedMailerWorker.drain }
        .not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  context 'the lockbox transaction is invalid' do
    before do
      allow_any_instance_of(LockboxTransaction).to receive(:valid?).and_return(false)
    end

    it 'does return an error message to the caller' do
      response = reconcile
      expect(response.outcome).to be :error
      expect(response.failure).to match(/Lockbox transaction not created: /)
    end

    it 'does not send out an email' do
      reconcile
      expect  { ReconciliationCompletedMailerWorker.drain }
        .not_to change { ActionMailer::Base.deliveries.count }
    end
  end

  context 'when the amount is valid' do
    before do
      allow(lockbox_partner)
        .to receive(:balance)
        .with(exclude_pending: true)
        .and_return(Monetize.parse('1000.00'))
    end

    context 'when the actual counted amount is less than the expected lockbox balance' do
      let(:amount) { Money.new(900_00) }

      it 'creates one lockbox action' do
        expect{reconcile}.to change(LockboxAction, :count).by(1)
      end

      it 'creates the lockbox action with the correct attributes' do
        lockbox_action = reconcile.value
        expect(lockbox_action.lockbox_partner_id).to eq(lockbox_partner.id)
        expect(lockbox_action.action_type).to eq(LockboxAction::RECONCILE)
        expect(lockbox_action.status).to eq(LockboxAction::COMPLETED)
      end

      it 'creates one lockbox transaction' do
        expect{reconcile}.to change(LockboxTransaction, :count).by(1)
      end

      it 'creates the lockbox transaction with the correct attributes' do
        lockbox_transaction = reconcile.value.lockbox_transactions.first
        expect(lockbox_transaction.eff_date).to eq(Date.current)
        expect(lockbox_transaction.amount).to eq(Monetize.parse('100.00'))
        expect(lockbox_transaction.balance_effect).to eq(LockboxTransaction::DEBIT)
      end
    end

    it 'creates one lockbox action' do
      expect{reconcile}.to change(LockboxAction, :count).by(1)
    end

    it 'creates the lockbox action with the correct attributes' do
      lockbox_action = reconcile.value
      expect(lockbox_action.lockbox_partner_id).to eq(lockbox_partner.id)
      expect(lockbox_action.action_type).to eq(LockboxAction::RECONCILE)
      expect(lockbox_action.status).to eq(LockboxAction::COMPLETED)
    end

    it 'creates one lockbox transaction' do
      expect{reconcile}.to change(LockboxTransaction, :count).by(1)
    end

    it 'creates the lockbox transaction with the correct attributes' do
      lockbox_transaction = reconcile.value.lockbox_transactions.first
      expect(lockbox_transaction.eff_date).to eq(Date.current)
      expect(lockbox_transaction.amount).to eq(Monetize.parse('100.00'))
      expect(lockbox_transaction.balance_effect).to eq(LockboxTransaction::CREDIT)
    end

    it 'does not send out an email immediately during reconciliation' do
      expect(LockboxPartnerMailer).not_to receive(:with)
      expect(LockboxPartnerMailer).not_to receive(:reconciliation_completed_alert)
    end

    it 'sends out a delayed email after reconciliation' do
      reconcile
      expect { ReconciliationCompletedMailerWorker.drain }.to change { ActionMailer::Base.deliveries.count }
    end
  end
end
