module Mache
  # Provides the mache DSL for nodes.
  module DSL
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods #:nodoc:
      def automation(*ids)
        ids.map { |id| %([data-automation="#{id}"]) }.join(" ")
      end

      def element(name, selector)
        define_method(name.to_s) do
          @node.find(selector)
        end
        define_helper_methods(name, selector)
      end

      def elements(name, selector)
        define_method(name.to_s) do
          @node.all(selector, minimum: 1)
        end
        define_helper_methods(name, selector)
      end

      def component(name, klass, selector)
        define_method(name.to_s) do
          klass.new(node: @node.find(selector))
        end
        define_helper_methods(name, selector)
      end

      def components(name, klass, selector)
        define_method(name.to_s) do
          @node.all(selector, minimum: 1).map do |element|
            klass.new(node: element)
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
