require "spec_helper"

require "mache/helpers/rails"
require "ostruct"

class MyPage < Mache::Page
  include Mache::Helpers::Rails::Flash
  flash "#flash"
end

RSpec.describe MyPage do
  subject(:page) { MyPage.new(node: node) }

  context "with no flash" do
    let(:node) do
      Capybara.string("")
    end

    it "has a flash" do
      expect(page).to_not have_flash
    end
  end

  context "with a flash notice" do
    let(:node) do
      Capybara.string <<-HTML
        <div id="flash" class="notice">
          lorem ipsum
        </div>
      HTML
    end

    it "has a flash" do
      expect(page).to have_flash
      expect(page).to have_notice_message("lorem ipsum")
      expect(page).to_not have_alert_message("lorem ipsum")
    end
  end

  context "with an error notice" do
    let(:node) do
      Capybara.string <<-HTML
        <div id="flash" class="error">
          lorem ipsum
        </div>
      HTML
    end

    it "has a flash" do
      expect(page).to have_flash
      expect(page).to_not have_notice_message("lorem ipsum")
      expect(page).to have_alert_message("lorem ipsum")
    end
  end
end
