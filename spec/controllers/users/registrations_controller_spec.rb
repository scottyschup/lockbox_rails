require 'rails_helper'

describe Users::RegistrationsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#new" do
    it "does not work" do
      expect{get :new}.to raise_error(ActionController::RoutingError)
    end
  end

  describe "#create" do
    let(:user) { build(:user) }

    subject do
      post :create, params: {
        user: {
          email: user.email,
          password: user.password,
          password_confirmation: user.password
        }
      }
    end

    it "does not work" do
      expect{subject}.to raise_error(ActionController::RoutingError)
    end
  end

  describe "#destroy" do
    let(:user) { create(:user) }

    subject do
      login_with(user)
      delete :destroy
    end

    it "does not work" do
      expect{subject}.to raise_error(ActionController::RoutingError)
    end
  end
end
