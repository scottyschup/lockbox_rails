require 'rails_helper'
require './lib/add_cash_to_lockbox'

describe AddCashToLockbox do
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner) }

  before do
    allow(LockboxActionMailer).to receive_message_chain(
      :with, :add_cash_email, :deliver_now
    )
  end

  def add_cash
    AddCashToLockbox.call(
      lockbox_partner: lockbox_partner,
      eff_date: 1.day.from_now,
      amount_cents: amount_cents
    )
  end

  context 'when the params are valid' do
    let(:amount_cents) { 10_000 }

    it "creates a lockbox action" do
      expect{add_cash}.to change(LockboxAction, :count).by(1)
    end

    it "creates a lockbox transaction" do
      expect{add_cash}.to change(LockboxTransaction, :count).by(1)
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
