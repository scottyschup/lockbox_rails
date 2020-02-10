require 'rails_helper'

describe UsersController do
  let(:user)       { create(:user, name: "Peaches", role: "admin") }
  let(:other_user) { create(:user, role: "partner") }
  let(:back)       { "from whence I came" }

  before do
    sign_in(user)
    request.env["HTTP_REFERER"] = back
  end

  context "When the user owns the account" do
    before { get :edit, params: { id: user.id } }
    let(:update_params) { { id: user.id, user: { name: "Matilda" } } }

    it "shows the edit form" do
      expect(response.status).to eq(200)
    end

    it "allows the update" do
      expect { patch :update, params: update_params }
        .to change { User.find(user.id).name }
        .from("Peaches")
        .to("Matilda")
    end
  end

  context "When the user does not own the account" do
    it "does not allow access" do
      get :edit, params: { id: other_user }
      expect(response).to redirect_to(back)
    end
  end
end
