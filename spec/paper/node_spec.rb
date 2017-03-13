require "spec_helper"

describe Mache::Node do
  subject { Mache::Node }

  describe ".component" do
    it "raises an error without a subclass of Component" do
      expect {
        subject.component(:foo, String, "bar")
      }.to raise_error(ArgumentError)
    end
  end

  describe ".components" do
    it "raises an error without a subclass of Component" do
      expect {
        subject.components(:foo, String, "bar")
      }.to raise_error(ArgumentError)
    end
  end
end
