require 'test_helper'

class LockboxTransactionTest < ActiveSupport::TestCase
  should belong_to(:lockbox_action)

  # test "the truth" do
  #   assert true
  # end
end
