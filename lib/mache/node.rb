require 'mache/dsl'

module Mache
  # The {Node} class represents a wrapped HTML page, or fragment. It exposes all
  # methods from the Mache DSL, and forwards any Capybara API methods to the
  # {#node} object.
  #
  # @abstract
  class Node
    include DSL

    # The underlying Capybara node object wrapped by this instance.
    #
    # @return [Capybara::Node] a node object
    attr_reader :node

    # Returns a new instance of Node.
    #
    # @param node [Capybara::Node] a Capybara node object to wrap
    def initialize(node:)
      @node ||= node
    end

    # Forwards any Capybara API calls to the node object.
    def method_missing(name, *args, &block)
      if @node.respond_to?(name)
        @node.send(name, *args, &block)
      else
        super
      end
    end

    # @!visibility private
    def respond_to_missing?(name, include_private = false)
      @node.respond_to?(name) || super
    end
  end
end
