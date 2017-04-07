module Mache
  module Helpers
    module Rails
      # The {Flash} module can be Included into page object classes that support
      # flash behaviour.
      #
      # rubocop:disable Style/PredicateName
      module Flash
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods # :nodoc:
          def flash(selector)
            element(:flash, selector)
          end
        end

        # Tests whether the page has a flash message.
        #
        # @param type [String, Symbol] a flash message type
        # @param text [Regexp, String] a value to match
        # @return `true` if the page has a matching message, `false` otherwise
        def has_message?(type, text)
          css_class = flash[:class] || ""
          regexp = text.is_a?(String) ? /\A#{Regexp.escape(text)}\Z/ : text
          css_class.include?(type.to_s) && flash.text.strip =~ regexp
        end

        # Tests whether the page has a success message.
        #
        # @param text [Regexp, String] a value to match
        # @return `true` if the page has a matching message, `false` otherwise
        def has_success_message?(text)
          has_message?(:success, text)
        end

        # Tests whether the page has a notice message.
        #
        # @param text [Regexp, String] a value to match
        # @return `true` if the page has a matching message, `false` otherwise
        def has_notice_message?(text)
          has_message?(:notice, text)
        end

        # Tests whether the page has an alert message.
        #
        # @param text [Regexp, String] a value to match
        # @return `true` if the page has a matching message, `false` otherwise
        def has_alert_message?(text)
          has_message?(:alert, text)
        end

        # Tests whether the page has an error message.
        #
        # @param text [Regexp, String] a value to match
        # @return `true` if the page has a matching message, `false` otherwise
        def has_error_message?(text)
          has_message?(:error, text)
        end
      end
      # rubocop:enable Style/PredicateName
    end
  end
end
