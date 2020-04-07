require 'rails_helper'

describe LockboxTransaction, type: :model do
  it { is_expected.to belong_to(:lockbox_action) }

  it 'validates the category' do
    transaction = LockboxTransaction.new(category: 'whaaaat')
    transaction.valid?
    expect(transaction.errors.messages[:category]).to include('is not included in the list')
  end

  it 'validates the effect' do
    transaction = LockboxTransaction.new(balance_effect: 'magic')
    transaction.valid?
    expect(transaction.errors.messages[:balance_effect]).to include('is not included in the list')
  end
end
