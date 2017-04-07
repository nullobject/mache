module Mache
  module Helpers
    module Rails
      # The {Routes} module can be included into page object classes that
      # support routing.
      module Routes
        def self.included(base)
          base.class_eval do
            include ::Rails.application.routes.url_helpers
          end
        end
      end
    end
  end
end
