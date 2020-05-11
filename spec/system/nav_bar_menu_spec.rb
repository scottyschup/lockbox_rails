require 'rails_helper'

RSpec.describe "Nav bar menu", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login_as(user, :scope => :user)
    visit("/")
  end

  context "navbar control button" do
    it "is present" do
      page.assert_selector("#navbar-control", visible: :visible, count: 1)
    end
  end

  context "clicking navbar control button" do
    it "opens navbar when closed" do
      click_button("navbar-control")
      page.assert_selector("#navbar", visible: :visible, count: 1)
    end

    it "closes navbar when opened" do
      click_button("navbar-control")
      page.assert_selector("#navbar", visible: :visible, count: 1)
      click_button("navbar-control")
      page.assert_selector("#navbar", visible: :hidden, count: 1)
    end

  end
end
