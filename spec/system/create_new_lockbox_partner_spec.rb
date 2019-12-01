require 'rails_helper'
require './lib/create_support_request'
include StyleHelper

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

    it "inputs are not styled as invalid" do
      sleep 0.1
      page.all(selector_string).each do |input|
        id = input.native.property(:id)
        expect(computed_style(selector: "##{id}", prop: "border-color")).to eq("rgb(0, 0, 0)")
      end
    end
  end

  context "On submission of blank form" do
    it "inputs are no longer pristine" do
      click_button("Add New Partner")
      sleep 1
      page.assert_no_selector(".pristine")
    end

    it "required inputs are marked as invalid" do
      click_button("Add New Partner")
      sleep 1
      page.all(selector_string).each do |input|
        id = input.native.property(:id)
        expect(computed_style(selector: "##{id}", prop: "border-color")).to eq("rgb(255, 0, 0)")
      end
    end
  end

end
