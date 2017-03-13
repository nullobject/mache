require "mache/node"

module Mache
  # The Component class wraps a fragment of HTML and can be used in any number
  # of {Page} classes using the `component` macro. A component can contain
  # elements and other components.
  #
  # @example
  #
  #   class NavItem < Mache::Component
  #     def selected?
  #       node[:class].include?("selected")
  #     end
  #   end
  #
  #   class Nav < Mache::Component
  #     components :items, NavItem, "a"
  #   end
  #
  # @abstract
  class Component < Node
  end
end
