require 'rails_helper'
require './lib/add_cash_to_lockbox'

describe AddCashToLockbox do
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner) }
  let(:eff_date) { 1.day.from_now.to_date }

  before do
    allow(LockboxActionMailer).to receive_message_chain(
      :with, :add_cash_email, :deliver_now
    )
  end

  def add_cash
    AddCashToLockbox.call(
      lockbox_partner: lockbox_partner,
      eff_date: eff_date,
      amount_cents: amount_cents
    )
  end

  context 'when the params are valid' do
    let(:amount_cents) { 10_000 }

    it "creates one lockbox action" do
      expect{add_cash}.to change(LockboxAction, :count).by(1)
    end

    it "creates the lockbox action with the correct attributes" do
      lockbox_action = add_cash.value
      expect(lockbox_action.lockbox_partner_id).to eq(lockbox_partner.id)
      expect(lockbox_action.action_type).to eq(LockboxAction::ADD_CASH)
      expect(lockbox_action.status).to eq(LockboxAction::PENDING)
    end

    it "creates one lockbox transaction" do
      expect{add_cash}.to change(LockboxTransaction, :count).by(1)
    end

    it "creates the lockbox transaction with the correct attributes" do
      lockbox_transaction = add_cash.value.lockbox_transactions.first
      expect(lockbox_transaction.eff_date).to eq(eff_date)
      expect(lockbox_transaction.amount_cents).to eq(amount_cents)
      expect(lockbox_transaction.balance_effect).to eq(LockboxTransaction::CREDIT)
    end

    it "emails the lockbox partner's users" do
      add_cash
      expect(LockboxActionMailer).to have_received(:with)
    end

    it "succeeds" do
      expect(add_cash.succeeded?).to be true
    end
  end

  context 'when the params are invalid' do
    let(:amount_cents) { "this is not a number" }

    it "does not create a lockbox action" do
      expect{add_cash}.not_to change(LockboxAction, :count)
    end

    it "does not create a lockbox transaction" do
      expect{add_cash}.not_to change(LockboxTransaction, :count)
    end

    it "does not email the lockbox partner's users" do
      add_cash
      expect(LockboxActionMailer).not_to have_received(:with)
    end

    it "fails" do
      expect(add_cash.succeeded?).to be false
    end
  end
end
