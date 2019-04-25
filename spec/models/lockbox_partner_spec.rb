require 'rails_helper'

describe LockboxPartner, type: :model do
  it { is_expected.to have_many(:users) }
end