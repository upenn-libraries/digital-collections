# frozen_string_literal: true

# Component for displaying one collection.
class CollectionCardComponent < ViewComponent::Base
  attr_reader :name, :representative_item, :heading_tag, :heading_class

  def initialize(name:, representative_item:, heading_tag: :h2, heading_class: nil)
    @name = name
    @representative_item = representative_item
    @heading_tag = heading_tag
    @heading_class = heading_class
  end

  def collection_facet_url
    search_catalog_path(f: { collection_ssim: [name] })
  end

  def preview_image_url
    "#{Settings.digital_repository.url}/v1/items/#{representative_item}/preview?size=350,350"
  end
end
