# frozen_string_literal: true

# Component for displaying a set of featured facet values (for example, sharing example collections).
class FeaturedListComponent < ViewComponent::Base
  renders_many :facets, ->(**params) { FeaturedFacetComponent.new(**params, heading_tag: @heading_tag, facet: @facet) }

  def initialize(facet: nil, heading_tag: :h2)
    @heading_tag = heading_tag
    @facet = facet
  end
end
