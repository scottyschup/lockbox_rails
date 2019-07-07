require 'rails_helper'

describe LockboxPartners::ReconciliationController do
  let(:authorized_lockbox_partner) { create(:lockbox_partner, :active) }
  let(:unauthorized_lockbox_partner) { create(:lockbox_partner, :active) }

  let(:user) { create(:user, role: user_role, lockbox_partner: user_lockbox_partner) }

  describe "#new" do
    before do
      sign_in(user)
      get :new, params: { lockbox_partner_id: authorized_lockbox_partner.id }
    end

    context "when the user is an admin" do
      let(:user_role) { User::ADMIN }
      let(:user_lockbox_partner) { nil }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user belongs to the correct partner" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { authorized_lockbox_partner }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user does not belong to the correct partner" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { unauthorized_lockbox_partner }

      it "returns 302" do
        expect(response.status).to eq(302)
      end
    end
  end
end
