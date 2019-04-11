require 'test_helper'

class SupportRequestTest < ActiveSupport::TestCase
  should belong_to(:lockbox_partner)

  test "it assigns a client_ref_id to new support requests" do
    # TODO
  end
end
