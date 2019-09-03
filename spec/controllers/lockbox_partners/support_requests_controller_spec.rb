require 'rails_helper'

describe LockboxPartners::SupportRequestsController do
  let(:support_request) { create(:support_request, :pending) }
  let(:user) { create(:user, role: User::PARTNER, lockbox_partner: support_request.lockbox_partner) }

  describe "#update_status" do
    it 'updates the status of the lockbox action associated with the support request' do
      sign_in(user)
      post :update_status, params: {
        lockbox_partner_id: support_request.lockbox_partner_id,
        support_request_id: support_request.id,
        status: 'completed'
      }
      expect(support_request.lockbox_action.reload.status).to eq 'completed'
    end
  end
end
