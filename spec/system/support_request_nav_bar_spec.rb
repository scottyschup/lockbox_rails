require 'rails_helper'
require './lib/create_support_request'

RSpec.describe "Support Request Nav Bar", type: :system do
  let!(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active, name: 'Gorillas R Us') }
  let!(:user)            { FactoryBot.create(:user) }

  let!(:current_support_request) do
    params = {
      lockbox_partner_id: lockbox_partner.id,
      name_or_alias: 'Leafy Greens',
      user_id: user.id,
      client_ref_id: 'meeps321',
      created_at: 2.days.ago,
      lockbox_action: {
        eff_date: Date.current,
        lockbox_transactions: [
          { amount: 50.to_money, category: LockboxTransaction::GAS }
        ]
      }
    }
    CreateSupportRequest.call!(params: params)
  end

  let!(:newer_support_request) do
    params = {
      lockbox_partner_id: lockbox_partner.id,
      name_or_alias: 'Leafy Greens',
      user_id: user.id,
      client_ref_id: 'meeps321',
      created_at: 1.days.ago,
      lockbox_action: {
        eff_date: Date.current,
        lockbox_transactions: [
          { amount: 50.to_money, category: LockboxTransaction::GAS }
        ]
      }
    }
    CreateSupportRequest.call!(params: params)
  end

  let!(:older_support_request) do
    params = {
      lockbox_partner_id: lockbox_partner.id,
      name_or_alias: 'Leafy Greens',
      user_id: user.id,
      client_ref_id: 'meeps321',
      created_at: 3.days.ago,
      lockbox_action: {
        eff_date: Date.current,
        lockbox_transactions: [
          { amount: 50.to_money, category: LockboxTransaction::GAS }
        ]
      }
    }
    CreateSupportRequest.call!(params: params)
  end

  let(:all_support_requests) do
    [newer_support_request, current_support_request, older_support_request]
  end

  before do
    login_as(user, :scope => :user)
    allow_any_instance_of(SupportRequest)
      .to receive(:all_support_requests_for_partner)
      .and_return(all_support_requests)
    visit "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{current_support_request.id}"
  end

  context "when there is a newer support request for a partner" do
    it "correctly identifies the next newer support request" do
      click_link("Newer Support Request")
      assert_current_path(
        lockbox_partner_support_request_path(lockbox_partner, newer_support_request)
      )
    end
  end

  context "when there is an older support request for a partner" do
    it "correctly identifies the next older support request" do
      click_link("Older Support Request")
      assert_current_path(
        lockbox_partner_support_request_path(lockbox_partner, older_support_request)
      )
    end
  end

  context "when there isn't a newer support request" do
    let(:all_support_requests) do
      [current_support_request, older_support_request]
    end

    it "only has a link for older support request" do
      expect(page).not_to have_link("Newer Support Request")
      expect(page).to have_link("Older Support Request")
    end
  end

  context "when there isn't an older support request" do
    let(:all_support_requests) do
      [newer_support_request, current_support_request]
    end

    it "only has a link for newer support request" do
      expect(page).to have_link("Newer Support Request")
      expect(page).not_to have_link("Older Support Request")
    end
  end
end
