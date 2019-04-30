require 'capybara'
require 'mache/node'

module Mache
  # The {Page} class wraps an HTML page with an application-specific API. You
  # can extend it to define your own API for manipulating the pages of your web
  # application.
  #
  # @example
  #
  #   class WelcomePage < Mache::page
  #     element :main, "#main"
  #     component :nav, Nav, "#nav"
  #   end
  #
  #   page = WelcomePage.new(path: "/welcome")
  #   page.visit
  #   page.current # true
  #   page.main.text # lorem ipsum
  #
  class Page < Node
    # The path where the page is located, without any domain information.
    #
    # @return [String] the path string
    # @example
    #   "/welcome"
    #   "/users/sign_in"
    attr_reader :path

    # Returns a new page object.
    #
    # @param node [Capybara::Node] a Capybara node to attach to
    # @param path [String] a path to where the page is located
    def initialize(node: Capybara.current_session, path: nil)
      @node = node
      @path = path
    end

    # Visits the page at its {#path}.
    #
    # @return [Page] a page object
    def visit
      @node.visit(path)
      self
    end

    # Tests whether the page is current.
    #
    # @return [Boolean] `true` if the page is current, `false` otherwise.
    def current?
      @node.current_path == path
    end

    # Creates a new page object and calls {#visit} on it.
    #
    # @return [Page] a page object
    def self.visit
      new.visit
    end
  end
end
