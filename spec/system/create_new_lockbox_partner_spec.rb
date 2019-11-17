require 'rails_helper'
require './lib/create_support_request'
include StyleHelper

RSpec.describe "Create new lockbox partner form", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:poltergeist)
    login_as(user, :scope => :user)
    visit("/")
    click_link("Create new lockbox partner")
  end

  context "On initial page load" do
    it "all inputs are present" do
      page.assert_selector("input:not([type=submit]), select", count: 7)
    end
    it "inputs are pristine and not styled as invalid" do
      page.assert_selector(".pristine", count: 7)
      page.all("input:not([type=submit]), select").each do |input|
        id = input.native.property(:id)
        puts id
        expect(computed_style(selector: "##{id}", prop: "border-color")).to eq("rgb(0, 0, 0)")
      end
    end
  end

  context "On submission of blank form" do
    before do
      page.find(".btn.btn-primary").click
    end

    it "inputs are no longer pristine" do
      page.assert_no_selector(".pristine")
    end

    describe "all required fields" do
      before do
        # binding.pry
        inputs = page.find("input[required]), select[required]")
      end

      it "are marked as required" do
        expect(inputs.length).to eq(6)
      end

      it "are marked invalid" do
        inputs.each do |input|
          id = input.native.property(:id)
          puts id
          expect(computed_style(selector: "##{id}", prop: "border-color")).to eq("rgb(255, 0, 0)")
        end
      end
    end
  end

end
