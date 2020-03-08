require 'rails_helper'

describe DashboardController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "#index" do
    context "for admin user" do
      before { user.update!(role: User::ADMIN) }

      it "loads all lockbox partners" do
        expect(LockboxPartner).to receive(:all)
        get :index
      end
    end

    context "for partner user" do
      before { user.update!(role: User::PARTNER) }

      it "only loads the partner user's lockbox" do
        expect(LockboxPartner).not_to receive(:all)
        get :index
      end
    end
  end

  describe "#support" do
    before { get :support }

    it "succeeds" do
      expect(response.status).to eq(200)
    end
  end

  describe "#onboarding_success" do
    before { get :onboarding_success }

    it "succeeds" do
      expect(response.status).to eq(200)
    end
  end
end
