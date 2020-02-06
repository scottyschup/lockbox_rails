require 'rails_helper'

describe DashboardController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "#support" do
    before { get :support }

    it "succeeds" do
      expect(response.status).to eq(200)
    end
  end
end
