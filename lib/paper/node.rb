require "capybara/dsl"
require "paper/dsl"

module Paper
  # An abstract class that wraps a capybara node object and exposes the capybara
  # and paper DSLs.
  class Node
    include Capybara::DSL
    include DSL

    attr_reader :node

    def initialize(node)
      @node = node
    end
  end
end
