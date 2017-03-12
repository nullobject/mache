module Mache
  # See {ClassMethods} for documentation.
  module DSL # :nodoc:
    def self.included(base)
      base.extend ClassMethods
    end

    # Provides a set of macro-like methods for wrapping HTML fragments in {Node}
    # objects.
    #
    # ## Elements
    #
    # The {#element} method wraps an HTML fragment in a {Node} and exposes it as
    # an *attribute* of the declaring class.
    #
    # The following example declares the `main` element, which is found on the
    # welcome page using the `#main` selector:
    #
    #     class WelcomePage < Mache::Page
    #       element :main, "#main"
    #     end
    #
    # The `main` element can be accessed as an attribute of a `WelcomePage`
    # instance:
    #
    #     page = WelcomePage.new
    #     page.has_main? # true
    #     page.main.text # lorem ipsum
    #
    # ## Components
    #
    # The {#component} method wraps an HTML fragment in a user-defined class and
    # exposes it as an *attribute* of the declaring class.
    #
    # The following example declaring the `alert` component, which is found on
    # the welcome page using the `#alert` selector. The component will be
    # wrapped in the user-defined `Alert` class:
    #
    #     class WelcomePage < Mache::Page
    #       component :alert, Alert, "#alert"
    #     end
    #
    # The `Alert` class can define an API for accessing the alert HTML fragment:
    #
    #     class Alert < Mache::Component
    #       element :close_button, "button.close"
    #
    #       def dismiss
    #         close_button.click
    #       end
    #     end
    #
    module ClassMethods
      def automation(*ids)
        ids.map { |id| %([data-automation="#{id}"]) }.join(" ")
      end

      # Defines an element that wraps an HTML fragment.
      #
      # @param name [String, Symbol] the elements collection name
      # @param selector [String] the selector to find the element
      # @param options [Hash] the options to pass to the Capybara finder
      def element(name, selector, options = {})
        define_method(name.to_s) do
          Node.new(node: @node.find(selector, options))
        end
        define_helper_methods(name, selector)
      end

      # Defines a collection of elements that wrap HTML fragments.
      #
      # @param name [String, Symbol] the elements collection name
      # @param selector [String] the selector to find the elements
      # @param options [Hash] the options to pass to the Capybara finder
      def elements(name, selector, options = {})
        options = {minimum: 1}.merge(options)
        define_method(name.to_s) do
          @node.all(selector, options).map do |node|
            Node.new(node: node)
          end
        end
        define_helper_methods(name, selector)
      end

      # Defines a component that wraps an HTML fragment.
      #
      # @param name [String, Symbol] the elements collection name
      # @param klass [Class] the component class
      # @param selector [String] the selector to find the component
      # @param options [Hash] the options to pass to the Capybara finder
      def component(name, klass, selector, options = {})
        define_method(name.to_s) do
          klass.new(node: @node.find(selector, options))
        end
        define_helper_methods(name, selector)
      end

      # Defines a collection of components that wrap HTML fragments.
      #
      # @param name [String, Symbol] the elements collection name
      # @param klass [Class] the component class
      # @param selector [String] the selector to find the components
      # @param options [Hash] the options to pass to the Capybara finder
      def components(name, klass, selector, options = {})
        options = {minimum: 1}.merge(options)
        define_method(name.to_s) do
          @node.all(selector, options).map do |node|
            klass.new(node: node)
          end
        end
        define_helper_methods(name, selector)
      end

      private

      def define_helper_methods(name, selector)
        define_existence_predicates(name, selector)
      end

      def define_existence_predicates(name, selector)
        define_method("has_#{name}?") do
          @node.has_selector?(selector)
        end

        define_method("has_no_#{name}?") do
          @node.has_no_selector?(selector)
        end
      end
    end
  end
end
