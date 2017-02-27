require "paper/node"

module Paper
  # A page provides a DSL for querying a wrapped capybara node object node. A
  # page can also has a path which can be visited.
  class Page < Node
    attr_reader :path

    def initialize(node: Capybara.current_session, path: nil)
      @node ||= node
      @path ||= path
    end

    def visit
      @node.visit(path)
      self
    end

    def current?
      @node.current_path == path
    end

    def self.visit
      new.tap(&:visit)
    end
  end
end
