require 'rails_helper'

RSpec.describe "Support Request Creation", type: :system do
  before do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
  end

  it 'can file a support request from main dashboad' do
    visit "/support_requests/new"

    fill_in 'First Name', with: 'Seabass'
    fill_in 'Last Name',  with: 'McGee'
    fill_in 'Phone Number', with: '8889992222'
    fill_in 'Email', with: 'cats@cats.com'
    fill_in 'Mailing Address', with: '123 Seaweed St, Ursula, WV 22334'

    click_button "Create Support case"

    assert_text 'Support Case'
  end
end
