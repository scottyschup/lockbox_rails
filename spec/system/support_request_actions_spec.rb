require 'rails_helper'
require './lib/create_support_request'

RSpec.describe "Support Request Actions", type: :system do
  let!(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active, name: 'Gorillas R Us') }
  let!(:user)            { FactoryBot.create(:user) }
  let!(:support_request) do
    params = {
      lockbox_partner_id: lockbox_partner.id,
      name_or_alias: 'Leafy Greens',
      user_id: user.id,
      client_ref_id: 'meeps321',
      lockbox_action_attributes: {
        eff_date: Date.current,
        lockbox_transactions_attributes:
        {
          "0":{ amount: "50", category: LockboxTransaction::MEDICINE }
        }
      }
    }
    CreateSupportRequest.call!(params: params)
  end

  before do
    login_as(user, :scope => :user)
  end

  it 'successfully view, edit, and add notes to a support request' do
    visit "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{support_request.id}"
    assert_selector "h3", text: "Support Request for Leafy Greens"
    click_link "Add Note"
    fill_in "note_text", with: "Here's some fine & fancy note text!"
    sleep(1)
    # Sleep for 1 second to avoid a race condition in slower environments (e.g., CircleCI)
    expect{ find_button("Save Note").click; sleep(1) }.to change{ support_request.notes.count }.by(1)
    click_link "Edit note"
    fill_in "note_text", with: "foobar"
    sleep(1)
    expect{ find_button("Save Note").click; sleep(1) }.to change { support_request.notes.last.text }.to("foobar")
  end

  it "successfully change the status of a support request" do
    visit "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{support_request.id}"
    click_link "Update Status"
    click_link "Completed"
    sleep(1)
    assert_selector "p.status-label", text: "Completed"
    expect(support_request.reload.status).to eq("completed")
  end

  it "successfully changes the name of a support request" do
    visit "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{support_request.id}"
    click_link "Edit Support Request"
    page.all(:fillable_field, 'Client Alias').last.set "Fleafy Greens"
    click_button "Submit"
    sleep(1)
    assert_selector "h3", text: "Fleafy Greens"
  end

  it "successfully add a transaction to a support request" do
    transaction_count = support_request.reload.lockbox_action.lockbox_transactions.count
    visit "/lockbox_partners/#{lockbox_partner.id}/support_requests/#{support_request.id}"
    click_link "Edit Support Request"
    click_link "Add more values +"
    all("option[value='childcare']")[1].click
    page.all(:fillable_field, 'Amount').last.set 10
    click_button "Submit"
    sleep(1)
    expect(support_request.reload.lockbox_action.lockbox_transactions.count).to eq(transaction_count + 1)
    assert_selector "div.support-request-details", text: "10.00 for childcare"
  end

  it 'exports the support requests' do
    visit '/'
    click_button 'navbar-control'
    click_link 'Financial Export'

    full_path = Rails.root.join("tmp/downloads/support_requests-#{Date.current}.csv")
    table = CSV.parse(File.read(full_path), headers: true)

    assert_equal('support_client', table[0]['Action type'])
    assert_equal('pending', table[0]['Status'])
    assert_equal(lockbox_partner.name, table[0]['Partner'])
    assert_equal(support_request.client_ref_id, table[0]['Client Reference ID'])
    assert_equal(support_request.created_at.to_s, table[0]['Date submitted'])
    assert_equal(Date.current.to_s, table[0]['Date of expense'])
  end
end
