require 'rails_helper'

describe Users::PasswordsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  context "New User Onboarding" do
    let!(:user) { create(:user, reset_password_token: 'tokey_mc_tokerson') }

    it "#edit" do
      get :edit, params: { reset_password_token: 'tokey_mc_tokerson' }
      expect(response.status).to eq(200)
    end

    it "#update" do
      post :update, params: { reset_password_token: 'tokey_mc_tokerson' }
      expect(response).to redirect_to(onboarding_success_path)
    end
  end

  context "When password reset token is stale" do
    it "#edit" do
      get :edit, params: { reset_password_token: 'tokey_mc_tokerson' }
      expect(response.status).to eq(200)
    end

    it "#update" do

    end
  end
end