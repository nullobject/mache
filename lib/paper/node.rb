require "paper/dsl"

module Paper
  # An abstract class that wraps a capybara node object and exposes the paper
  # DSL. It also delegates any capybara methods to the underlying node object.
  class Node
    include DSL

    attr_reader :node

    def initialize(node)
      @node = node
    end

    def method_missing(name, *args, &block)
      if @node.respond_to?(name)
        @node.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      @node.respond_to?(name) || super
    end
  end
end
