require 'rails_helper'

describe LockboxAction, type: :model do
  it { is_expected.to belong_to(:lockbox_partner) }
  it { is_expected.to have_many(:lockbox_transactions) }
end