require 'rails_helper'

describe SupportRequest, type: :model do
  it { is_expected.to belong_to(:lockbox_partner) }
end