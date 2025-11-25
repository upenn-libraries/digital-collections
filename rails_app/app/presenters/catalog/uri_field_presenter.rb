# frozen_string_literal: true

module Catalog
  # Ensures URI fields render as hyperlinks for non-json requests
  # Custom Blacklight::FieldPresenter subclass based on Blacklight v9.0.0.beta8
  class URIFieldPresenter < Catalog::FieldPresenter
    # @return [Array]
    def values
      @values ||= if json_request?
                    super
                  else
                    retrieve_values.map { |value| view_context.link_to(value, value) }
                  end
    end
  end
end
