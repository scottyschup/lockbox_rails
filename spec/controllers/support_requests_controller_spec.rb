require 'rails_helper'

describe SupportRequestsController do

  describe "#index" do
    context "when the user is an admin" do
      it "returns 200" do
        user = create(:user, role: User::ADMIN)
        sign_in(user)
        get :index
        expect(response.status).to eq(200)
      end
    end

    context "when the user is not an admin" do
      it "returns 302" do
        user = create(:user, role: User::PARTNER)
        sign_in(user)
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

