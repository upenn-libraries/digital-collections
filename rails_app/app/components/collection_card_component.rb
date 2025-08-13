# frozen_string_literal: true

# Component for displaying one collection.
class CollectionCardComponent < ViewComponent::Base
  attr_reader :name, :representative_item, :header_tag

  def initialize(name:, representative_item:, header_tag: :h2)
    @name = name
    @representative_item = representative_item
    @header_tag = header_tag
  end

  def collection_facet_url
    search_catalog_path(f: { collection_ssim: [name] })
  end

  def preview_image_url
    "#{Settings.digital_repository.url}/v1/items/#{representative_item}/preview?size=350,350"
  end
end
