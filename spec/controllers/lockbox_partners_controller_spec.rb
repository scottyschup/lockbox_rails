require 'rails_helper'

describe LockboxPartnersController do
  let(:authorized_lockbox_partner) { create(:lockbox_partner, :active) }
  let(:unauthorized_lockbox_partner) { create(:lockbox_partner, :active) }

  let(:user) { create(:user, role: user_role, lockbox_partner: user_lockbox_partner) }

  describe "#new" do
    let(:user_lockbox_partner) { nil }

    before do
      sign_in(user)
      get :new
    end

    context "when the user is an admin" do
      let(:user_role) { User::ADMIN }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin" do
      let(:user_role) { User::PARTNER }

      it "returns 302" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "show" do
    before do
      sign_in(user)
      get :show, params: { id: authorized_lockbox_partner.id }
    end

    context "when the user is an admin" do
      let(:user_role) { User::ADMIN }
      let(:user_lockbox_partner) { nil }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin but a lockbox owner" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { authorized_lockbox_partner }

      it "returns 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin and doesn't belong to the lockbox" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { unauthorized_lockbox_partner }

      it "returns 302" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
