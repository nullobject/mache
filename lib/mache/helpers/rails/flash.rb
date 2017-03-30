module Mache
  module Helpers
    module Rails
      # The {Flash} module can be Included into page object classes that support
      # flash behaviour.
      module Flash
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods # :nodoc:
          def flash(selector)
            element :flash, selector
          end
        end

        # rubocop:disable Style/PredicateName
        def has_notice_message?(text)
          css_class = flash[:class] || ""
          css_class.include?("notice") && flash.text =~ /\s*#{text}\s*/
        end

        def has_alert_message?(text)
          css_class = flash[:class] || ""
          css_class.include?("error") && flash.text =~ /\s*#{text}\s*/
        end
        # rubocop:enable Style/PredicateName
      end
    end
  end
end
