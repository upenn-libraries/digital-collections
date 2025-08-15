# frozen_string_literal: true

module Catalog
  # Overrides Blacklight::FieldPresenter based on BL v9.0.0beta1@de5ddb to ensure fields are not joined and
  # html links are not included in json responses
  class FieldPresenter < Blacklight::FieldPresenter
    def initialize(view_context, document, field_config, options = {})
      super
      @except_operations += [Blacklight::Rendering::Join]
      @except_operations += [Blacklight::Rendering::LinkToFacet] if json_request?
    end

    # @return [Array]
    def render
      Array.wrap super
    end

    private

    # @return [Boolean]
    def json_request?
      return false unless view_context.respond_to?(:search_state)

      view_context.search_state&.params&.dig(:format) == 'json'
    end
  end
end
