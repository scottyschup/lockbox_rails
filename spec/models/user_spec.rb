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

  describe "#status" do
    let(:user) { FactoryBot.create(:user) } # creates active user by default

    context 'when confirmed_at is nil' do
      before { user.update!(confirmed_at: nil) }
      it "status is pending" do
        expect(user.status).to eq("pending")
      end
    end

    context 'when locked_at is non-nil' do
      before { user.update!(locked_at: Time.current) }
      it "status is locked" do
        expect(user.status).to eq("locked")
      end
    end

    context 'when user has been confirmed but is not locked' do
      it "status is active" do
        expect(user.status).to eq("active")
      end
    end
  end
end
