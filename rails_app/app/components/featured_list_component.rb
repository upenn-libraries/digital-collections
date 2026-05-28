# frozen_string_literal: true

# Component for displaying a set of featured facet values (for example, sharing example collections).
class FeaturedListComponent < ViewComponent::Base
  renders_many :facets, ->(**params) { FeaturedFacetComponent.new(**params, heading_tag: @heading_tag, facet: @facet) }

  # List of featured facets.
  #
  # @param facet [String] facet; solr field
  # @param heading_tag [Symbol] html tag for list item headers
  def initialize(facet: nil, heading_tag: :h2)
    @heading_tag = heading_tag
    @facet = facet
  end
end
