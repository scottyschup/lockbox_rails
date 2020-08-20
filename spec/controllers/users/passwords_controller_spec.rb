require 'rails_helper'

describe Users::PasswordsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  context "New User Onboarding" do
    let!(:user) { create(:user) }
    let(:token) { user.send_reset_password_instructions }

    it "#edit" do
      get :edit, params: { reset_password_token: token }
      expect(response.status).to eq(200)
      expect(response).to render_template('devise/passwords/edit')
    end

    it "#update" do
      post :update, params: {
        user: {
          reset_password_token: token,
          password: 'password1234',
          password_confirmation: 'password1234'
        }
      }
      expect(response).to redirect_to(onboarding_success_path)
    end
  end

  context "When password reset token is stale" do
    let!(:user) { create(:user) }
    let!(:token) { user.send_reset_password_instructions }
    before do
      user.update_attribute(:reset_password_sent_at, 7.hours.ago)
    end

    it "#edit" do
      get :edit, params: { reset_password_token: token }
      expect(response.status).to eq(404)
    end

    it "#update" do
      post :update, params: {
        user: {
          reset_password_token: token,
          password: 'password1234',
          password_confirmation: 'password1234'
        }
      }
      expect(response.status).to eq(404)
    end
  end
end
