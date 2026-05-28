# frozen_string_literal: true

# Component for displaying one featured facet.
class FeaturedFacetComponent < ViewComponent::Base
  attr_reader :name, :facet, :representative_item, :heading_tag

  # Card to represent facet within a featured set.
  #
  # @param name [String] display name and facet value
  # @param facet [String] facet; solr field
  # @param representative_item [String] item uuid
  # @param heading_tag [Symbol] html tag for header
  def initialize(name:, facet:, representative_item: nil, heading_tag: :h2)
    @name = name # Display name
    @facet = facet # Solr facet field
    @representative_item = representative_item
    @heading_tag = heading_tag
  end

  def collection_facet_url
    search_catalog_path(f: { "#{facet}": [name] })
  end

  def representative_item?
    representative_item&.present?
  end

  def preview_image_url
    return unless representative_item?

    DigitalRepository.new.item_preview_url(representative_item, 'size=350,350')
  end
end
