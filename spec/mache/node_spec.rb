require 'spec_helper'

RSpec.describe Mache::Node do
  let(:capybara_node) { double }

  subject(:node) { Mache::Node.new(node: capybara_node) }

  describe '.component' do
    it 'raises an error without a subclass of Node' do
      expect {
        Mache::Node.component(:foo, String, 'bar')
      }.to raise_error(ArgumentError)
    end
  end

  describe '.components' do
    it 'raises an error without a subclass of Node' do
      expect {
        Mache::Node.components(:foo, String, 'bar')
      }.to raise_error(ArgumentError)
    end
  end

  describe '#empty?' do
    it 'returns true if the node is empty' do
      allow(capybara_node).to receive(:all).and_return(double(length: 0))
      expect(node.empty?).to be(true)
    end

    it 'returns false otherwise' do
      allow(capybara_node).to receive(:all).and_return(double(length: 1))
      expect(node.empty?).to be(false)
    end
  end
end
