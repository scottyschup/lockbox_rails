require 'rails_helper'

describe User, type: :model do
  it { is_expected.to belong_to(:lockbox_partner).optional }
end