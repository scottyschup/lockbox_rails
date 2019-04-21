require 'rails_helper'

describe Note, type: :model do
  it { is_expected.to belong_to(:notable) }
end