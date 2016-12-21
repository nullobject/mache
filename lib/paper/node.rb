require "capybara/dsl"
require "paper/dsl"

module Paper
  class Node
    include Capybara::DSL
    include DSL

    attr_reader :node

    def initialize(node)
      @node = node
    end
  end
end
