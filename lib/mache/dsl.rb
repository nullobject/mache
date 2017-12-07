module Mache
  # The {DSL} module is mixed into the {Node} class to provide the DSL for
  # defining elements and components.
  #
  # See {ClassMethods} for documentation.
  module DSL
    def self.included(base)
      base.extend(ClassMethods)
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
    #     class Alert < Mache::Node
    #       element :close_button, "button.close"
    #
    #       def dismiss
    #         close_button.click
    #       end
    #     end
    #
    module ClassMethods
      def automation(*ids)
        ids.map { |id| %([data-automation="#{id}"]) }.join(' ')
      end

      # Defines an element that wraps an HTML fragment.
      #
      # @param name [String, Symbol] a name for the element
      # @param selector [String] a selector to find the element
      # @param options [Hash] a hash of options to pass to the Capybara finder
      def element(name, selector, options = {})
        define_method(name.to_s) do
          Node.new(node: @node.find(selector, options))
        end

        define_helper_methods(name, selector)
      end

      # Defines a collection of elements that wrap HTML fragments.
      #
      # @param name [String, Symbol] a name for the elements collection
      # @param selector [String] a selector to find the elements
      # @param options [Hash] a hash of options to pass to the Capybara finder
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
      # @param name [String, Symbol] a name for the component
      # @param klass [Class] a component class
      # @param selector [String] a selector to find the component
      # @param options [Hash] a hash of options to pass to the Capybara finder
      def component(name, klass, selector, options = {})
        unless klass < Node
          raise ArgumentError, 'Must be given a subclass of Node'
        end

        define_method(name.to_s) do
          klass.new(node: @node.find(selector, options))
        end

        define_helper_methods(name, selector)
      end

      # Defines a collection of components that wrap HTML fragments.
      #
      # @param name [String, Symbol] a name for the components collection
      # @param klass [Class] a component class
      # @param selector [String] a selector to find the components
      # @param options [Hash] a hash of options to pass to the Capybara finder
      def components(name, klass, selector, options = {})
        unless klass < Node
          raise ArgumentError, 'Must be given a subclass of Node'
        end

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
