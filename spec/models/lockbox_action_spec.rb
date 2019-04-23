require 'rails_helper'

describe LockboxAction, type: :model do
  it { is_expected.to belong_to(:lockbox_partner) }
  it { is_expected.to have_many(:lockbox_transactions) }
  it { is_expected.to have_many(:notes) }

  context '.create_with_transactions' do
    context 'some unknown action type' do
      # it raises some meaningful error
    end

    context 'add_cash' do
      # given an amount and a date
      # creates a corresponding credit txn
      # no category
    end

    context 'reconcile' do
      # given an amount and a date
      # compares amount to balance
      # creates an adjustment if amount counted != amount expected
      # (credit if amount counted > amount expected)
      # (debit if amount counted < amount expected)
    end

    context 'support_client' do
      # given an amount, a date, and a cost breakdown
      # cost breakdown is an array of hashes containing amount & category
      # may create multiple debit txns depending on items in cost breakdown
    end
  end
end