require "paper/node"

module Paper
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
      new.tap { |page| page.visit }
    end
  end
end
