require "spec_helper"

RSpec.describe Mache::Page do
  let(:node) { double }
  let(:path) { "/my-page" }

  subject(:page) { Mache::Page.new(node: node, path: path) }

  describe ".visit" do
    let(:page) { double }

    it "creates a new page and visits it" do
      expect(Mache::Page).to receive(:new).and_return(page)
      expect(page).to receive(:visit)
      Mache::Page.visit
    end
  end

  describe "#visit" do
    it "visits the page" do
      expect(node).to receive(:visit).with(path)
      page.visit
    end
  end

  describe "#current?" do
    it "returns true when the page is current" do
      expect(node).to receive(:current_path).and_return("/my-page")
      expect(page).to be_current
    end

    it "returns false when the page is not current" do
      expect(node).to receive(:current_path).and_return("/another-page")
      expect(page).to_not be_current
    end
  end
end
