require 'test_helper'

class LockboxActionTest < ActiveSupport::TestCase
  should belong_to(:lockbox_partner)
  should have_many(:lockbox_transactions)

  # test "the truth" do
  #   assert true
  # end
end
