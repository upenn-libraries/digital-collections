# frozen_string_literal: true

module Catalog
  # Ensures names with creator roles appear first and display values link to the facet values without roles
  # Limits number of elements by provided 'limit' field configuration value
  # Custom Blacklight::FieldPresenter subclass based on Blacklight v9.0.0.beta8
  class NameWithRolePresenter < Catalog::FieldPresenter
    CREATOR_ROLE = 'creator'
    FACET_FIELD = 'name_ssim'
    # Override #values method to return field values as links to faceted search for non-json requests
    # returns display values for json requests
    # @return [Array]
    def values
      @values ||= if json_request?
                    display_facet_pairs.map(&:first)
                  else
                    display_facet_pairs.map { |display, facet| link_to_facet(display, facet) }
                  end
    end

    private

    def link_to_facet(display, facet)
      view_context.link_to(display, view_context.search_action_path({ "f[#{FACET_FIELD}][]": facet }))
    end

    # @raise [ArgumentError] if number of display values is different to number of facet values
    # @return [Array<Array<String>>] array of [display, facet] pairs sorted by creator roles first
    def display_facet_pairs
      @display_facet_pairs ||= begin
        validate_array_lengths!
        pairs = display_values.zip(facets).sort_by { |display, _facet| creator?(display) ? 0 : 1 }
        pairs.first(field_config.limit || pairs.length)
      end
    end

    # @param name_with_role [String]
    # @return [Boolean]
    def creator?(name_with_role)
      name_with_role.include?(CREATOR_ROLE)
    end

    # @return [Array<String>]
    def facets
      document.fetch(FACET_FIELD, [])
    end

    # @return [Array<String>]
    def display_values
      @display_values ||= retrieve_values
    end

    # Validates that display values and facets have matching lengths
    # @raise [ArgumentError] if number of display values is different to number of facet values
    # @return [Nil]
    def validate_array_lengths!
      return if display_values.length == facets.length

      document_id = document.fetch(:id)
      raise ArgumentError,
            "Mismatch between name_with_role_tesim (#{display_values.length}) and " \
              "name_ssim (#{facets.length}) in document #{document_id}"
    end
  end
end
