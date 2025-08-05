# frozen_string_literal: true

class CollectionCardComponent < ViewComponent::Base
  attr_reader :name, :representative_item

  def initialize(name:, representative_item:)
    @name = name
    @representative_item = representative_item
  end

  def collection_facet_url
    search_catalog_path(f: { collection_ssim: [name] })
  end

  def preview_image_url
    "#{Settings.digital_repository.url}/v1/items/#{representative_item}/preview?size=350,350"
  end
end