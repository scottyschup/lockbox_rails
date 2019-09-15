require 'rails_helper'

describe LockboxPartners::SupportRequestsController do
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

    context "when the user is not an admin" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { authorized_lockbox_partner }

      it "redirects" do
        expect(response.status).to eq(302)
      end
    end
  end

  describe "#show" do
    let(:support_request) { FactoryBot.create(:support_request, lockbox_partner: authorized_lockbox_partner) }

    before do
      sign_in(user)
      get :show, params: { lockbox_partner_id: authorized_lockbox_partner.id, id: support_request.id }
    end

    context "when the user is an admin" do
      let(:user_role) { User::ADMIN }
      let(:user_lockbox_partner) { nil }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin but is a lockbox owner" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { authorized_lockbox_partner }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin and does not belong to the lockbox" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { unauthorized_lockbox_partner }

      it "redirects" do
        expect(response.status).to eq(302)
      end
    end
  end
end
