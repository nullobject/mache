require "mache/helpers/rails"
require "spec_helper"

class MyPage < Mache::Page
  include Mache::Helpers::Rails::Flash
  flash "#flash"
end

RSpec.describe MyPage do
  subject(:page) { MyPage.new(node: node) }

  context "with a success message" do
    let(:node) do
      Capybara.string <<-HTML
        <div id="flash" class="success">
          lorem ipsum
        </div>
      HTML
    end

    it "has a flash" do
      expect(page).to have_flash
    end

    it "matches text" do
      expect(page).to have_message(:success, "lorem ipsum")
      expect(page).to_not have_message(:success, "lorem")
    end

    it "matches a regexp" do
      expect(page).to have_message(:success, /\Alorem ipsum\Z/)
      expect(page).to have_message(:success, /lorem/)
    end

    it "matches with convenience matchers" do
      expect(page).to have_success_message("lorem ipsum")
      expect(page).to_not have_notice_message("lorem ipsum")
      expect(page).to_not have_alert_message("lorem ipsum")
      expect(page).to_not have_error_message("lorem ipsum")
    end
  end

  context "with no flash" do
    let(:node) do
      Capybara.string("")
    end

    it "has no flash" do
      expect(page).to_not have_flash
    end
  end
end
