require 'test_helper'

class LockboxActionTest < ActiveSupport::TestCase
  should belong_to(:lockbox_partner)

  # test "the truth" do
  #   assert true
  # end
end
