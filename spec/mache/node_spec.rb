require 'spec_helper'

RSpec.describe Mache::Node do
  subject(:node) { Mache::Node }

  describe '.component' do
    it 'raises an error without a subclass of Node' do
      expect {
        node.component(:foo, String, 'bar')
      }.to raise_error(ArgumentError)
    end
  end

  describe '.components' do
    it 'raises an error without a subclass of Node' do
      expect {
        node.components(:foo, String, 'bar')
      }.to raise_error(ArgumentError)
    end
  end
end
