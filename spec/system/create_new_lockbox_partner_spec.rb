require 'rails_helper'
require './lib/create_support_request'

RSpec.describe "Create new lockbox partner form", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  selector_string = "input:not([type=submit]):not([type=hidden]), select"

  before do
    login_as(user, :scope => :user)
    visit("/")
    click_link("Create new lockbox partner")
  end

  context "On initial page load" do
    it "all inputs are present" do
      page.assert_selector(selector_string, count: 7)
    end

    it "inputs are pristine" do
      page.assert_selector(".pristine", count: 7)
    end
  end

  context "On submission of blank form" do
    it "inputs are no longer pristine" do
      click_button("Add New Partner")
      page.assert_no_selector(".pristine")
    end
  end

end
