require "spec_helper"

describe Paper::Page do
  let(:node) { double }
  let(:path) { "/my-page" }

  subject(:page) { Paper::Page.new(node: node, path: path) }

  describe "#visit" do
    it "visits the path" do
      expect(node).to receive(:visit).with(path)
      page.visit
    end
  end

  describe "#current?" do
    it "returns true when the page is current" do
      expect(node).to receive(:current_path) { "/my-page" }
      expect(page).to be_current
    end

    it "returns false when the page is not current" do
      expect(node).to receive(:current_path) { "/another-page" }
      expect(page).to_not be_current
    end
  end
end
