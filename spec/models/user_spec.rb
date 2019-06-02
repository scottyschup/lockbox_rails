require 'rails_helper'

describe User, type: :model do
  it { is_expected.to belong_to(:lockbox_partner).optional }

  describe "#has_signed_in?" do
    let(:user) { FactoryBot.build(:user, last_sign_in_at: last_sign_in_at) }
    subject { user.has_signed_in? }

    context "when last_sign_in_at is nil" do
      let(:last_sign_in_at) { nil }

      it { is_expected.to be false }
    end

    context "when last_sign_in_at is not nil" do
      let(:last_sign_in_at) { 1.hour.ago }

      it { is_expected.to be true }
    end
  end
end
