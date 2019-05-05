require 'rails_helper'

describe LockboxTransaction, type: :model do
  it { is_expected.to belong_to(:lockbox_action) }
end
