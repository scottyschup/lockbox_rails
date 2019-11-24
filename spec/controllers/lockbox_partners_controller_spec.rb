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

  describe "#create" do
    let(:user_lockbox_partner) { nil }

    before do
      @lockbox_partner_count = LockboxPartner.count
      sign_in(user)
      post :create, params: {
        lockbox_partner: {
          name: "new partner",
          street_address: "123 some st",
          city: "City",
          state: "IL",
          zip_code: "12345",
          phone_number: "3125551234"
        }
      }
    end

    context "when the user is an admin" do
      let(:user_role) { User::ADMIN }

      it "creates a lockbox partner" do
        expect(LockboxPartner.count).to eq( @lockbox_partner_count + 1 )
      end

      it "redirects to the new partner" do
        expect(response).to redirect_to(lockbox_partner_path(LockboxPartner.last))
      end
    end

    context "when the user is not an admin" do
      let(:user_role) { User::PARTNER }

      it "returns 302" do
        expect(response).to redirect_to(root_path)
      end

      it "does not create a lockbox partner" do
        expect(LockboxPartner.count).to eq(@lockbox_partner_count)
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

  describe "#edit" do
    before do
      sign_in(user)
      get :edit, params: { id: authorized_lockbox_partner.id }
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

  describe "#update" do
    before do
      @new_name = authorized_lockbox_partner.name + SecureRandom.uuid
      sign_in(user)
      put :update, params: {
        id: authorized_lockbox_partner.id,
        lockbox_partner: {
          name: @new_name
        }
      }
    end

    context "when the user is an admin" do
      let(:user_role) { User::ADMIN }
      let(:user_lockbox_partner) { nil }

      it "updates the partner" do
        expect(authorized_lockbox_partner.reload.name).to eq(@new_name)
      end

      it "redirects to the partner" do
        expect(response).to redirect_to(lockbox_partner_path(authorized_lockbox_partner))
      end
    end

    context "when the user is not an admin but a lockbox owner" do
      let(:user_role) { User::PARTNER }
      let(:user_lockbox_partner) { authorized_lockbox_partner }

      it "updates the partner" do
        expect(authorized_lockbox_partner.reload.name).to eq(@new_name)
      end

      it "redirects to the partner" do
        expect(response).to redirect_to(lockbox_partner_path(authorized_lockbox_partner))
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
